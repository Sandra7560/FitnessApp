import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class WorkoutHistoryViewModel: ObservableObject {
    @Published var workoutHistory: [Workout] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    // Function to load workout history from Firebase
    func loadWorkoutHistory() {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "User not logged in"
            print("User is not logged in")
            return
        }
        
        isLoading = true
        let db = Database.database().reference()
        
        // Fetch workout history from Firebase Realtime Database
        db.child("users").child(user.uid).child("workouts").observeSingleEvent(of: .value) { snapshot, _ in
            self.isLoading = false
            print("Snapshot data: \(snapshot.value ?? "No data")")
            // Ensure error handling is not needed anymore
            guard let data = snapshot.value as? [String: Any] else {
                       self.errorMessage = "No workout history found."
                       print("No workout history found.") // Debugging print
                       return
                   }

            var workouts: [Workout] = []
            for (_, value) in data {
                if let workoutData = value as? [String: Any] {
                    let title = workoutData["title"] as? String ?? "No Title"
                    let difficulty = workoutData["difficulty"] as? String ?? "Unknown"
                    let duration = workoutData["duration"] as? String ?? "Unknown"
                    let videoLink = workoutData["videoLink"] as? String ?? ""
                    let streak = workoutData["streak"] as? Int ?? 0

                    let workout = Workout(
                        title: title,
                        difficulty: difficulty,
                        duration: duration,
                        videoLink: videoLink,
                        streak: streak
                    )
                    workouts.append(workout)
                }
            }
            if workouts.isEmpty {
                        self.errorMessage = "No workout history found."
                        print("No workouts in the data") // Debugging print
                    }
            self.workoutHistory = workouts
        }
    }
    
    
    // Function to save a workout to Firebase
    func saveWorkoutToFirebase(workout: Workout) {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Database.database().reference()
        let workoutData: [String: Any] = [
            "title": workout.title,
            "difficulty": workout.difficulty,
            "duration": workout.duration,
            "videoLink": workout.videoLink,
            "streak": workout.streak
        ]

        // Save workout to Firebase Realtime Database
        db.child("users").child(user.uid).child("workouts").childByAutoId().setValue(workoutData) { error, _ in
            if let error = error {
                print("Error saving workout: \(error.localizedDescription)")
            } else {
                print("Workout saved successfully")
            }
        }
    }
}
