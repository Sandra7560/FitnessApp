//
//  Timerpage.swift
//  FitnessApp
//
//  Created by sandra sudheendran on 2024-11-25.
//

import SwiftUI

struct TimerPage: View {
    @State private var timeRemaining: Int // Time in seconds
    @State private var currentExercise = "Push-Ups" // Current exercise being performed
    @State private var isRunning = false // Flag to control timer running state
    @State private var timer: Timer? = nil // Timer object to manage the countdown
    
    // Accepting workoutDuration as an argument
    var workoutDuration: Int
    
    init(workoutDuration: Int) {
        // Initializing timeRemaining with workoutDuration in seconds
        self.workoutDuration = workoutDuration
        _timeRemaining = State(initialValue: workoutDuration * 60) // Convert minutes to seconds
    }
    
    var body: some View {
        VStack {
            Text("Current Exercise: \(currentExercise)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Time Remaining: \(timeRemaining) seconds")
                .font(.title2)
                .padding()
            
            Spacer()
            
            // Progress Circle (Timer)
            Circle()
                .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(workoutDuration * 60))
                .stroke(Color.blue, lineWidth: 10)
                .frame(width: 200, height: 200)
                .rotationEffect(Angle(degrees: -90))
            
            Spacer()
            
            // Buttons (Start, Pause, Stop)
            HStack {
                // Start Button
                if !isRunning {
                    Button(action: startTimer) {
                        Text("Start")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                
                // Pause Button
                if isRunning {
                    Button(action: pauseTimer) {
                        Text("Pause")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                
                // Stop Button
                Button(action: stopTimer) {
                    Text("Stop")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onDisappear {
            // Stop the timer if the view disappears
            timer?.invalidate()
        }
    }
    
    // Start Timer
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate() // Stop the timer when time runs out
            }
        }
    }
    
    // Pause Timer
    func pauseTimer() {
        isRunning = false
        timer?.invalidate() // Stop the timer
    }
    
    // Stop Timer
    func stopTimer() {
        isRunning = false
        timeRemaining = workoutDuration * 60 // Reset the timer
        timer?.invalidate() // Stop the timer
    }
}


