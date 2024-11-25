import SwiftUI

struct WorkoutDetailView: View {
    var workout: Workout
    var workoutDuration: Int // Duration passed from HomePage (in minutes)
    
    var body: some View {
        NavigationView {
            VStack {
                Text(workout.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Difficulty: \(workout.difficulty)")
                    .font(.title2)
                    .padding()
                
                Text("Duration: \(workoutDuration) minutes") // Display duration passed from HomePage
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                // Placeholder for workout instructions
                Text("Instructions and workout details go here...")
                    .font(.body)
                    .padding()
                
                Spacer()
                
                // Navigation to ExerciseTracking (TimerPage) with workout duration
                NavigationLink(destination: TimerPage(workoutDuration: workoutDuration)) {
                    Text("Start Workout")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle(workout.title, displayMode: .inline)
        }
    }
}
