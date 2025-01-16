import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct WorkoutDetailView: View {
    var workout: Workout
    var workoutDuration: Int
    @State private var completed = false
    
    @StateObject private var viewModel = WorkoutHistoryViewModel()  // Use @StateObject to observe the view model

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.black.opacity(0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(workout.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.7), radius: 4, x: 0, y: 2)
                
                VStack(spacing: 10) {
                    Text("Difficulty: \(workout.difficulty)")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Duration: \(workoutDuration) minutes") // Display duration passed from HomePage
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                
                Spacer()
                
                Image("image1.jpeg") // Replace with the actual image name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Spacer()
                
                // Video Link Button - Add a button to open the workout video
                Link("Watch Video Tutorial", destination: URL(string: workout.videoLink)!)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.green]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                    .padding(.top, 20)
            
                // NavigationLink with action to save workout data before navigating
                NavigationLink(destination: TimerPage(workoutDuration: workoutDuration, title: workout.title, difficulty: workout.difficulty)) {
                    Text("Start Workout")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                        .onAppear {
                            saveWorkoutToFirebase() // Save workout data when the "Start Workout" button appears
                        }
                }
                .padding()
            }
            .padding()
        }
        .navigationBarTitle(workout.title, displayMode: .inline)
    }
    
    // Function to save workout data to Firebase (without completion date)
    private func saveWorkoutToFirebase() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Database.database().reference()
        
        // Creating the workout data dictionary to be saved to Firebase
        let workoutData: [String: Any] = [
            "title": workout.title,
            "difficulty": workout.difficulty,
            "duration": workout.duration,
            "videoLink": workout.videoLink,
            "streak": 1 // You can adjust this based on the user's streak logic
        ]
        
        // Save workout data to Firebase Realtime Database
        db.child("users").child(user.uid).child("workouts").childByAutoId().setValue(workoutData) { error, _ in
            if let error = error {
                print("Error saving workout: \(error.localizedDescription)")
            } else {
                print("Workout saved successfully")
            }
        }
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(workout: Workout(title: "Full Body in 10 Minutes", difficulty: "Beginner", duration: "10 min", videoLink: "https://youtu.be/XXXXX1",streak: 1), workoutDuration: 10)
    }
}
