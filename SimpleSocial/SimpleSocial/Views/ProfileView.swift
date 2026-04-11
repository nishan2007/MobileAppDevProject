//
//  ProfileView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI

struct ProfileView: View {
    let currentUserName: String
    let onLogoutTapped: () -> Void
    @State private var errorMessage: String? = nil

    private func logout() {
        errorMessage = nil

        Task {
            do {
                try await AuthService.shared.logout()
                onLogoutTapped()
            } catch let error as AuthServiceError {
                errorMessage = error.errorDescription
                print("Logout failed: \(error)")
            } catch {
                errorMessage = "Something went wrong. Try again"
                print("Logout failed: \(error)")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 92))
                        .foregroundStyle(.blue)
                        .padding(.top, 20)

                    Text(currentUserName)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("@\(currentUserName.lowercased())")
                        .foregroundStyle(.secondary)

                    Text("Sharing thoughts, interests, and updates on Simple Social.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 28)

                    HStack(spacing: 30) {
                        ProfileStatView(title: "Posts", value: "12")
                        ProfileStatView(title: "Following", value: "58")
                        ProfileStatView(title: "Followers", value: "143")
                    }
                    .padding(.top, 6)

                    Button(action: logout) {
                        Text("Log Out")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.9))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 24)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileStatView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView(
        currentUserName: "Nishan",
        onLogoutTapped: {}
    )
}
