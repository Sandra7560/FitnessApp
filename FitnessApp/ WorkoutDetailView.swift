//
//   WorkoutDetailView.swift
//  FitnessApp
//
//  Created by sandra sudheendran on 2024-11-22.
//

import Foundation
import SwiftUI

struct WorkoutDetailView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            Text(workout.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Difficulty: \(workout.difficulty)")
                .font(.title2)
                .padding()
            
            Text("Duration: \(workout.duration)")
                .font(.title2)
                .padding()
            
            Spacer()
            
            // Placeholder for workout instructions, video, or timer
            Text("Instructions and workout details go here...")
                .font(.body)
                .padding()
            
            Spacer()
            
            // Start Workout Button (Can trigger a timer, etc.)
            Button(action: {
                // Code to start workout (timer, etc.)
            }) {
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
