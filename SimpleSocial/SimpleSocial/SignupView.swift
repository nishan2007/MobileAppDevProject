//
//  SignupView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI
import ParseSwift

struct SignUpView: View {
    @Binding var username: String
    let onCreateAccountTapped: () -> Void
    let onBackToLoginTapped: () -> Void

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    private var isFormValid: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }
    
    
    private func createAccount() {
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password

        Task {
            do {
                _ = try await newUser.signup()
                onCreateAccountTapped()
            } catch {
                print("Sign up failed: \(error)")
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 30)

                    Text("Join Simple Social and share posts in your favorite categories.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    VStack(spacing: 14) {
                        TextField("Username", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 8)

                    if !confirmPassword.isEmpty && password != confirmPassword {
                        Text("Passwords do not match.")
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button(action: createAccount) {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1 : 0.5)

                    Button(action: onBackToLoginTapped) {
                        Text("Back to Login")
                            .fontWeight(.medium)
                    }

                    Spacer()
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    SignUpView(
        username: .constant(""),
        onCreateAccountTapped: {},
        onBackToLoginTapped: {}
    )
}
