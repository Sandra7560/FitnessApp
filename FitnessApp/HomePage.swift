import SwiftUI
import Firebase
import FirebaseAuth

struct Workout: Identifiable {
    var id = UUID()
    var title: String
    var difficulty: String
    var duration: String
}

struct HomePage: View {
    let workouts = [
        Workout(title: "Full Body in 10 Minutes", difficulty: "Beginner", duration: "10 min"),
        Workout(title: "Core Strengthening", difficulty: "Intermediate", duration: "15 min"),
        Workout(title: "Leg Day Challenge", difficulty: "Advanced", duration: "20 min")
    ]
    
    @State private var navigateToSignIn = false  // State to trigger navigation to SignIn view

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
                    
                    List {
                        ForEach(workouts) { workout in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(workout.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    HStack {
                                        Text(workout.difficulty)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        
                                        Text("|")
                                            .foregroundColor(.gray)
                                        
                                        Text(workout.duration)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                Spacer()
                                
                                // Extract duration from the string and convert it to an Int
                                let workoutDuration = Int(workout.duration.prefix(2)) ?? 0
                                
                                // Pass workout and workoutDuration to WorkoutDetailView
                                NavigationLink(destination: WorkoutDetailView(workout: workout, workoutDuration: workoutDuration)) {
                                    Text("Start")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(10)
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
                    
                    // Reminder Button
                    NavigationLink(destination: ReminderPage()) {
                        Text("Set Workout Reminders")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.green]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 20)
                    
                    // Logout Button
                    Button(action: signOut) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.orange]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 20)
                    .background(
                        NavigationLink(destination: SignInView(), isActive: $navigateToSignIn) {
                            EmptyView()
                        }
                    )
                    
                    // Profile Button
                    NavigationLink(destination: ProfileView()) {
                        Text("Go to Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true) // Hides the default navigation bar
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            navigateToSignIn = true // Trigger navigation to SignIn view after logout
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
