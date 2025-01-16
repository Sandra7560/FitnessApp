import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct TimerPage: View {
    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    @State private var streak: Int = 0
    @State private var workoutTitle: String = ""
    @State private var workoutDifficulty: String = ""

    var workoutDuration: Int

    init(workoutDuration: Int, title: String, difficulty: String) {
        self.workoutDuration = workoutDuration
        self.workoutTitle = title
        self.workoutDifficulty = difficulty
        _timeRemaining = State(initialValue: workoutDuration * 60)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Time Remaining")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(formattedTime(timeRemaining))
                    .font(.system(size: isRunning ? 60 : 40, weight: .bold, design: .rounded))
                    .foregroundColor(isRunning ? .red : .white)
                    .scaleEffect(isRunning ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.5), value: isRunning)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.1))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3))

                Image("image1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)

                HStack(spacing: 20) {
                    if !isRunning {
                        Button(action: startTimer) {
                            Text("Start")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 120)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }

                    if isRunning {
                        Button(action: pauseTimer) {
                            Text("Pause")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 120)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }

                    Button(action: stopTimer) {
                        Text("Stop")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 120)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .onAppear {
            loadWorkoutHistory()
        }
        .navigationBarTitle("Timer", displayMode: .inline)
    }

    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                saveWorkoutToFirebase()
            }
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    func stopTimer() {
        isRunning = false
        timeRemaining = workoutDuration * 60
        timer?.invalidate()
    }

    func formattedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func loadWorkoutHistory() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        let db = Database.database().reference()
        let workoutRef = db.child("users").child(user.uid).child("workouts").queryOrdered(byChild: "completionDate").queryLimited(toLast: 1)

        workoutRef.observeSingleEvent(of: .value) { snapshot in
            if let lastWorkoutSnapshot = snapshot.children.allObjects.first as? DataSnapshot {
                let workoutData = lastWorkoutSnapshot.value as? [String: Any]
                if let completionDate = workoutData?["completionDate"] as? Double {
                    let lastCompletionDate = Date(timeIntervalSince1970: completionDate)
                    let calendar = Calendar.current
                    if calendar.isDateInYesterday(lastCompletionDate) {
                        streak += 1
                    } else {
                        streak = 1
                    }
                }
            }
        }
    }

    func saveWorkoutToFirebase() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        let db = Database.database().reference()

        let workoutData: [String: Any] = [
            "title": workoutTitle,
            "difficulty": workoutDifficulty,
            "duration": workoutDuration,
            "completed": true,
            "completionDate": Date().timeIntervalSince1970, // Save as Unix timestamp
            "streak": streak
        ]

        let workoutRef = db.child("users").child(user.uid).child("workouts").childByAutoId()
        workoutRef.setValue(workoutData) { error, _ in
            if let error = error {
                print("Error saving workout: \(error.localizedDescription)")
            } else {
                print("Workout saved successfully!")
            }
        }
    }
}

struct TimerPage_Previews: PreviewProvider {
    static var previews: some View {
        TimerPage(workoutDuration: 10, title: "Full Body Workout", difficulty: "Intermediate")
    }
}
