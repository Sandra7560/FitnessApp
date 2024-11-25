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
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.black.opacity(0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Current Exercise: \(currentExercise)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.7), radius: 4, x: 0, y: 2)
                
                Text("Time Remaining: \(formattedTime(timeRemaining))")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                
                Spacer()
                
                // Progress Circle (Timer)
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 15)
                        .frame(width: 250, height: 250)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(workoutDuration * 60))
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 15
                        )
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 250, height: 250)
                        .animation(.easeInOut(duration: 0.2), value: timeRemaining)
                    
                    Text(formattedTime(timeRemaining))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Buttons (Start, Pause, Stop)
                HStack(spacing: 20) {
                    // Start Button
                    if !isRunning {
                        Button(action: startTimer) {
                            Text("Start")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
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
                                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
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
                            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                }
                .padding()
            }
            .padding()
        }
        .onDisappear {
            // Stop the timer if the view disappears
            timer?.invalidate()
        }
        .navigationBarTitle("Timer", displayMode: .inline)
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
    
    // Format time in MM:SS
    func formattedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
