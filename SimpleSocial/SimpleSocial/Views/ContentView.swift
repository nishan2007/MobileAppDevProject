//
//  ContentView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = AuthService.shared.currentDisplayName()
    @State private var currentScreen: Screen = AuthService.shared.isLoggedIn() ? .main : .login

    enum Screen {
        case login
        case signup
        case main
    }

    var body: some View {
        switch currentScreen {
        case .login:
            LoginView(
                username: $username,
                onLoginTapped: {
                    username = AuthService.shared.currentDisplayName()
                    currentScreen = .main
                },
                onSignUpTapped: {
                    currentScreen = .signup
                }
            )

        case .signup:
            SignUpView(
                username: $username,
                onCreateAccountTapped: {
                    username = AuthService.shared.currentDisplayName()
                    currentScreen = .main
                },
                onBackToLoginTapped: {
                    currentScreen = .login
                }
            )

        case .main:
            MainAppView(
                currentUserName: username.isEmpty ? AuthService.shared.currentDisplayName() : username,
                onLogoutTapped: {
                    username = ""
                    currentScreen = .login
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
