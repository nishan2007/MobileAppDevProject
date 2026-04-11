//
//  LoginView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//


//
//  LoginView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI
import ParseSwift

struct LoginView: View {
    @Binding var username: String
    let onLoginTapped: () -> Void
    let onSignUpTapped: () -> Void

    @State private var password: String = ""

    
    private func login() {
        Task {
            do {
                _ = try await User.login(username: username, password: password)
                onLoginTapped()
            } catch {
                print("Login failed: \(error)")
            }
        }
    }
    
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.15), .purple.opacity(0.12)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    // App Icon
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)

                    // Title
                    Text("Simple Social")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Connect through posts, interests, and communities.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    // Input Fields
                    VStack(spacing: 14) {
                        TextField("Username", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 10)

                    // Login Button
                    Button(action: login) {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(username.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty)
                    .opacity((username.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty) ? 0.5 : 1)

                    // Sign Up Navigation
                    Button(action: onSignUpTapped) {
                        Text("Don't have an account? Sign Up")
                            .fontWeight(.medium)
                    }
                    .padding(.top, 6)

                    Spacer()
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    LoginView(
        username: .constant(""),
        onLoginTapped: {},
        onSignUpTapped: {}
    )
}
