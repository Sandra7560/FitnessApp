//
//  HomePage.swift
//  FitnessApp
//
//  Created by sandra sudheendran on 2024-11-22.
//

import Foundation
import SwiftUI

// Workout model
struct Workout: Identifiable {
    var id = UUID()
    var title: String
    var difficulty: String
    var duration: String
}

// Home Page displaying workout list
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
                        
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
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
