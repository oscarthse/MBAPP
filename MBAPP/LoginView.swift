import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if authViewModel.isLoggedIn {
                MainView()
            } else {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)

                Button(action: {
                    authViewModel.login(email: email, password: password) { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding(.top, 20)

                Button(action: {
                    authViewModel.register(email: email, password: password) { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            authViewModel.isLoggedIn = Auth.auth().currentUser != nil
        }
        .padding()
    }
}
