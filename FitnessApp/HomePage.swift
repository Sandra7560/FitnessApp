import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

struct Workout: Identifiable {
    var id = UUID()
    var title: String
    var difficulty: String
    var duration: String
    var videoLink: String
    var completed: Bool = false // Track if the user completed this workout
 
    var streak: Int
}

struct HomePage: View {
    let workouts = [
        Workout(title: "Full Body in 10 Minutes", difficulty: "Beginner", duration: "10 min", videoLink: "https://youtu.be/cbKkB3POqaY?si=FMByqlPwqZSKHaIC",  streak: 5),
        Workout(title: "Core Strengthening", difficulty: "Intermediate", duration: "15 min", videoLink: "https://youtu.be/Zma_7kh-FGA?si=w2ieSmRGu-eMHCFH",  streak: 3), // Previous day
        Workout(title: "Leg Day Challenge", difficulty: "Advanced", duration: "20 min", videoLink: "https://youtu.be/Jg61m0DwURs?si=AxJudA20kJ3Zg64p",  streak: 7) // Optional
    ]
    @State private var currentStreak = 0
    @State private var navigateToSignIn = false

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.purple.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Workout Hub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Display Streak
//                    Text("Current Streak: \(currentStreak) days")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .padding(.bottom, 20)

                    List {
                        ForEach(workouts) { workout in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(workout.title)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        Text(workout.difficulty)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        
                                        Text("|")
                                            .foregroundColor(.white)
                                        
                                        Text(workout.duration)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Spacer()
                                
                                // Extract duration from the string and convert it to an Int
                                let workoutDuration = Int(workout.duration.prefix(2)) ?? 0
                                
                                NavigationLink(destination: WorkoutDetailView(workout: workout, workoutDuration: workoutDuration)) {
                                    Text("Start")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 14)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden) // Ensures background is transparent
                    
                    Spacer()
                    
                    // Horizontal Icons
                    HStack(spacing: 40) {
                        // Reminder Icon
                        NavigationLink(destination: ReminderPage()) {
                            VStack {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.yellow)
                                
                                Text("Reminders")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                        }

                        // Profile Icon
                        NavigationLink(destination: ProfileView()) {
                            VStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                
                                Text("Profile")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                        }
                        //workouthistory
                        NavigationLink(destination: WorkoutHistoryView()){
                            VStack{
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                Text("History")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                
                            }
                        }

                        // Logout Icon
                        Button(action: signOut) {
                            VStack {
                                Image(systemName: "arrow.backward.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.red)
                                
                                Text("Logout")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                        }
                        .fullScreenCover(isPresented: $navigateToSignIn) {
                                        SignInView() // This is where the user will be redirected
                                    }
                        
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true) // Hides the default navigation bar
//        .onAppear {
//            fetchStreakFromFirebase()
//        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            navigateToSignIn = true // Trigger navigation to SignIn view after logout
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }

//    func fetchStreakFromFirebase() {
//        guard let user = Auth.auth().currentUser else { return }
//
//        let db = Database.database().reference()
//
//        // Fetch the streak value from the "workoutData" node in Realtime Database
//        db.child("workoutData").child(user.uid).observeSingleEvent(of: .value) { snapshot, error in
//            if let error = error {
//                print("Error fetching streak: \(error.localizedDescription)")
//                return
//            }
//
//            if let data = snapshot.value as? [String: Any] {
//                let userStreak = data["streak"] as? Int ?? 0
//                self.streak = userStreak
//            } else {
//                print("No user data found")
//            }
//        }
//    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
