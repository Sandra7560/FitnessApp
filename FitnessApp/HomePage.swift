import SwiftUI

// Workout model
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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Workout Hub")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                List(workouts) { workout in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(workout.title)
                                .font(.headline)
                            HStack {
                                Text(workout.difficulty)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("|")
                                Text(workout.duration)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
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
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
#Preview {
    HomePage()
}
