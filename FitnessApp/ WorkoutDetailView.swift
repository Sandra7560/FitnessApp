import SwiftUI

struct WorkoutDetailView: View {
    var workout: Workout
    var workoutDuration: Int // Duration passed from HomePage (in minutes)
    
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
                
                // Placeholder for workout instructions
                Text("Instructions and workout details go here...")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Spacer()
                
                // Navigation to ExerciseTracking (TimerPage) with workout duration
                NavigationLink(destination: TimerPage(workoutDuration: workoutDuration)) {
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
                }
                .padding()
            }
            .padding()
        }
        .navigationBarTitle(workout.title, displayMode: .inline)
    }
}
