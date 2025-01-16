import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct ProfileView: View {
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var userPhone: String = "" // New phone number
    @State private var userAddress: String = "" // New address
    @State private var isEditing = false // To toggle between view and edit mode
    @State private var newUserPhone: String = ""
    @State private var newUserAddress: String = ""
    @State private var navigateToSignIn = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.purple.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // Display User's Profile Information
                    if isEditing {
                        // Editable fields for phone number and address
                        TextField("Enter your phone number", text: $newUserPhone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            .foregroundColor(.black)

                        TextField("Enter your address", text: $newUserAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            .foregroundColor(.black)

                    } else {
                        // Display the current information from Firebase Authentication and Database
                        Text("Name: \(userName)")
                            .font(.title2)
                            .foregroundColor(.white)

                        Text("Email: \(userEmail)")
                            .font(.title2)
                            .foregroundColor(.white)

                        Text("Phone: \(userPhone)")
                            .font(.title2)
                            .foregroundColor(.white)

                        Text("Address: \(userAddress)")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Horizontal Icons at the bottom
                    HStack(spacing: 50) {
                        // Edit Profile Icon
                        Button(action: toggleEditMode) {
                            VStack {
                                Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                
                                Text(isEditing ? "Save" : "Edit")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                        }

                        // Logout Icon
                        Button(action: signOut) {
                            VStack {
                                Image(systemName: "arrow.backward.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                
                                Text("Logout")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                        }
                        .fullScreenCover(isPresented: $navigateToSignIn) {
                                        SignInView() // This is where the user will be redirected
                                    } 
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .onAppear {
                    fetchUserProfile()
                }
            }
            .navigationBarHidden(true) // Hides the default navigation bar
        }
    }
    
    // Fetch user profile from Firebase Realtime Database
    private func fetchUserProfile() {
        if let currentUser = Auth.auth().currentUser {
            userName = currentUser.displayName ?? "No name available"
            userEmail = currentUser.email ?? "No email available"
            
            // Fetch additional details from Firebase Realtime Database
            let ref = Database.database().reference()
            let userRef = ref.child("users").child(currentUser.uid)

            userRef.observeSingleEvent(of: .value) { snapshot in
                if let userData = snapshot.value as? [String: Any] {
                    userPhone = userData["phone"] as? String ?? "No phone number available"
                    userAddress = userData["address"] as? String ?? "No address available"
                    
                    newUserPhone = userPhone
                    newUserAddress = userAddress
                }
            }
        }
    }

    // Toggle between edit and save mode
    private func toggleEditMode() {
        if isEditing {
            saveProfile()
        }
        isEditing.toggle()
    }

    // Save profile to Firebase Realtime Database
    private func saveProfile() {
        guard !newUserPhone.isEmpty, !newUserAddress.isEmpty else {
            // Handle empty fields if necessary
            return
        }

        if let currentUser = Auth.auth().currentUser {
            // Save data to Firebase Realtime Database
            let ref = Database.database().reference()
            let userRef = ref.child("users").child(currentUser.uid)
            
            // Prepare user data dictionary (don't update name and email, use Firebase Authentication)
            let userData: [String: Any] = [
                "phone": newUserPhone,
                "address": newUserAddress
            ]
            
            // Update the Realtime Database with the new user details
            userRef.setValue(userData) { error, _ in
                if let error = error {
                    print("Failed to save user data: \(error.localizedDescription)")
                } else {
                    print("User data saved")
                    
                    // After saving the profile, fetch the updated data to refresh the UI
                    fetchUserProfile()
                }
            }
        }
    }

    // Sign out the user
    private func signOut() {
        do {
            try Auth.auth().signOut()
            navigateToSignIn = true
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
