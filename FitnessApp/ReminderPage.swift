import SwiftUI
import Firebase
import FirebaseDatabase

struct ReminderPage: View {
    @State private var reminders: [Reminder] = [] // Array to store multiple reminders
    @State private var newReminderTime = Date() // New reminder time
    @State private var newReminderLabel = "" // New reminder label
    @State private var confirmationMessage = ""
    private var databaseRef: DatabaseReference! // Firebase Realtime Database reference

    init() {
        // Initialize Firebase database reference
        databaseRef = Database.database().reference()
    }

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.black.opacity(0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Set Workout Reminders")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.7), radius: 4, x: 0, y: 2)

                // TextField for entering label for the reminder
                TextField("Enter a label for this reminder", text: $newReminderLabel)
                    .font(.title2)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 20)

                // DatePicker to select time for the reminder
                VStack(spacing: 20) {
                    Text("Select Reminder Time")
                        .font(.title2)
                        .foregroundColor(.white)

                    DatePicker("Select Time", selection: $newReminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                }

                Button(action: {
                    addReminder()
                }) {
                    Text("Add New Reminder")
                        .font(.title2)
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

                // List of all reminders
                VStack(spacing: 20) {
                    ForEach(reminders, id: \.id) { reminder in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(reminder.label)
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("Reminder set for: \(reminder.time, formatter: timeFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()

                            Button(action: {
                                removeReminder(reminder)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                }

                Spacer()

                if !confirmationMessage.isEmpty {
                    Text(confirmationMessage)
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitle("Reminders", displayMode: .inline)
        .onAppear {
            loadReminders()
        }
    }

    // Add a new reminder to the list
    func addReminder() {
        // Ensure the user has entered a label
        guard !newReminderLabel.isEmpty else {
            confirmationMessage = "Please enter a label for the reminder."
            return
        }

        let newReminder = Reminder(label: newReminderLabel, time: newReminderTime)
        reminders.append(newReminder)
        saveReminderToFirebase(reminder: newReminder)
        confirmationMessage = "Reminder set for \(timeFormatter.string(from: newReminder.time))"
        
        // Clear input fields
        newReminderLabel = ""
        newReminderTime = Date()
    }

    // Remove a reminder
    func removeReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders.remove(at: index)
            deleteReminderFromFirebase(reminder: reminder)
            confirmationMessage = "Reminder removed"
        }
    }

    // Save reminder to Firebase
    func saveReminderToFirebase(reminder: Reminder) {
        let reminderData: [String: Any] = [
            "label": reminder.label,
            "time": reminder.time.timeIntervalSince1970 // Saving as timestamp
        ]

        let reminderRef = databaseRef.child("reminders").childByAutoId()
        reminderRef.setValue(reminderData) { error, _ in
            if let error = error {
                print("Error saving reminder to Firebase: \(error.localizedDescription)")
            } else {
                print("Reminder saved to Firebase")
            }
        }
    }

    // Delete reminder from Firebase
    func deleteReminderFromFirebase(reminder: Reminder) {
        // Find the Firebase ID for the reminder and delete it
        let reminderRef = databaseRef.child("reminders").child(reminder.id.uuidString)
        reminderRef.removeValue { error, _ in
            if let error = error {
                print("Error removing reminder from Firebase: \(error.localizedDescription)")
            } else {
                print("Reminder removed from Firebase")
            }
        }
    }

    // Load reminders from Firebase
    func loadReminders() {
        databaseRef.child("reminders").observe(.value) { snapshot in
            var loadedReminders: [Reminder] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let reminderDict = snapshot.value as? [String: Any],
                   let label = reminderDict["label"] as? String,
                   let timeInterval = reminderDict["time"] as? TimeInterval {
                    let reminder = Reminder(id: UUID(), label: label, time: Date(timeIntervalSince1970: timeInterval))
                    loadedReminders.append(reminder)
                }
            }
            reminders = loadedReminders
        }
    }
}

// Time formatter to display the reminder time
let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

// Reminder struct to store reminder details
struct Reminder: Identifiable, Codable {
    var id: UUID = UUID() // UUID is generated automatically
    var label: String // Label for the reminder
    var time: Date
}

#Preview {
    ReminderPage()
}
