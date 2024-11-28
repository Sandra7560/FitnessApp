import SwiftUI



// Shared ViewModel

// Shared ViewModel
class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = [
        Workout(title: "Full Body in 10 Minutes", difficulty: "Beginner", duration: "10 min"),
        Workout(title: "Core Strengthening", difficulty: "Intermediate", duration: "15 min")
    ]
    
    func addWorkout(workout: Workout) {
        workouts.append(workout)
    }
    
    func deleteWorkout(workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
    }
}

struct AdminDashboard: View {
    @ObservedObject var workoutVM = WorkoutViewModel() // Use the shared view model
    
    @State private var showAddWorkoutForm = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Linear Gradient as background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.purple.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea() // Ensures the gradient covers the entire screen
                
                VStack {
                    // Workout Management Section
                    List {
                        Section(header: Text("Workouts").foregroundColor(.black)) {
                            ForEach(workoutVM.workouts) { workout in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(workout.title)
                                            .font(.headline)
                                            .foregroundColor(.black) // White text for visibility
                                        Text("\(workout.difficulty) | \(workout.duration)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(action: {
                                        workoutVM.deleteWorkout(workout: workout)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .foregroundColor(.white) // Ensures list text is visible

                    // Add Workout Button
                    Button(action: {
                        showAddWorkoutForm.toggle()
                    }) {
                        Text("Add New Workout")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showAddWorkoutForm) {
                        AddWorkoutForm(workoutVM: workoutVM) // Pass the view model
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Admin", displayMode: .inline)
        }
    }
}

struct AddWorkoutForm: View {
    @Environment(\.presentationMode) var presentationMode // This allows us to dismiss the sheet
    @ObservedObject var workoutVM: WorkoutViewModel // Observing the shared view model
    
    @State private var title = ""
    @State private var difficulty = "Beginner"
    @State private var duration = ""
    
    let difficulties = ["Beginner", "Intermediate", "Advanced"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Workout Title", text: $title)
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(difficulties, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Duration (e.g., 10 min)", text: $duration)
                
                Button(action: {
                    let newWorkout = Workout(title: title, difficulty: difficulty, duration: duration)
                    workoutVM.addWorkout(workout: newWorkout) // Add the workout to the shared view model
                    presentationMode.wrappedValue.dismiss() // Dismiss the form and return to AdminDashboard
                }) {
                    Text("Add Workout")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Workout")
            // The back button will be automatically available as we're in a NavigationView
        }
    }
}
// Preview
struct AdminDashboard_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboard()
    }
}
