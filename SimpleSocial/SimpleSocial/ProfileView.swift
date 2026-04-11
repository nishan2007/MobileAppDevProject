//
//  ProfileView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI
import ParseSwift

struct ProfileView: View {
    let currentUserName: String
    let onLogoutTapped: () -> Void

    private func logout() {
        Task {
            do {
                try await User.logout()
                onLogoutTapped()
            } catch {
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

                    Button(action: onLogoutTapped) {
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
