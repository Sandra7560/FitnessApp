import SwiftUI

struct WorkoutHistoryView: View {
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

            VStack {
                Text("Workout History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()

                ScrollView {
                    // Check for error messages or if no workout history exists
                    if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.workoutHistory.isEmpty {
                        Text("No workouts found.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding()
                    } else {
                        // Loop through the workout history and display it
                        ForEach(viewModel.workoutHistory) { workout in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(workout.title)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text("Duration: \(workout.duration) min")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Text("Streak: \(workout.streak) days")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                            .padding(.horizontal) // Add padding for spacing between items
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .onAppear {
            viewModel.loadWorkoutHistory()  // Load workout history when the view appears
        }
    }
}

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
    }
}
