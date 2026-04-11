//
//  ContentView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var currentScreen: Screen = .login

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
                    currentScreen = .main
                },
                onBackToLoginTapped: {
                    currentScreen = .login
                }
            )

        case .main:
            MainAppView(
                currentUserName: username.isEmpty ? "User" : username,
                onLogoutTapped: {
                    currentScreen = .login
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
