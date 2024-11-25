//
//  ReminderPage.swift
//  FitnessApp
//
//  Created by sandra sudheendran on 2024-11-25.
//

import SwiftUI

struct ReminderPage: View {
    @State private var reminderEnabled = false
    @State private var reminderTime = Date()
    @State private var confirmationMessage = ""
    
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
                
                Toggle(isOn: $reminderEnabled) {
                    Text("Enable Reminders")
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                
                if reminderEnabled {
                    VStack(spacing: 20) {
                        Text("Set Reminder Time")
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
                
                Button(action: saveReminder) {
                    Text("Save Reminder")
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
                .padding(.bottom, 40)
                
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
    }
    
    // Save reminder time
    func saveReminder() {
        if reminderEnabled {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let timeString = formatter.string(from: reminderTime)
            
            // Save to UserDefaults
            UserDefaults.standard.set(reminderTime, forKey: "WorkoutReminderTime")
            UserDefaults.standard.set(reminderEnabled, forKey: "WorkoutReminderEnabled")
            
            confirmationMessage = "Reminder set for \(timeString)"
        } else {
            // Clear stored reminder if disabled
            UserDefaults.standard.removeObject(forKey: "WorkoutReminderTime")
            UserDefaults.standard.removeObject(forKey: "WorkoutReminderEnabled")
            confirmationMessage = "Reminder disabled"
        }
    }
}

#Preview {
    ReminderPage()
}
