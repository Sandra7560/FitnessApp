import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isSignedIn = false

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.purple.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.black)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.black)

                    Button(action: signIn) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                    }
                    .padding()

                    Button(action: resetPassword) {
                        Text("Forgot Password?")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer()

                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.white)
                    }

                    // Navigation to HomePage after successful sign-in
                    NavigationLink(destination: HomePage(), isActive: $isSignedIn) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
            } else {
                self.errorMessage = ""
                self.showError = false
                print("Sign In Successful!")
                self.isSignedIn = true
            }
        }
    }

    private func resetPassword() {
        guard !email.isEmpty else {
            self.errorMessage = "Please enter your email to reset your password."
            self.showError = true
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
            } else {
                self.errorMessage = "Password reset email sent. Please check your inbox."
                self.showError = true
            }
        }
    }
}

#Preview {
    SignInView()
}
