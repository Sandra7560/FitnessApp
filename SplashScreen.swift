//
//  SplashScreen.swift
//  FitnessApp
//
//  Created by sandra sudheendran on 2024-11-25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            SignInView()// Navigate to the HomePage after the splash screen
        } else {
            ZStack {
                //test akil
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "figure.walk")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    Text("Workout Hub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                .opacity(0.8)
            }
            .onAppear {
                // Delay for 2 seconds before navigating
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}

