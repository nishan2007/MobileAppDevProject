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
    }

    var body: some View {
        switch currentScreen {
        case .login:
            LoginView(
                username: $username,
                onLoginTapped: {
                    // later we’ll go to main app
                },
                onSignUpTapped: {
                    currentScreen = .signup
                }
            )

        case .signup:
            SignUpView(
                username: $username,
                onCreateAccountTapped: {
                    currentScreen = .login
                },
                onBackToLoginTapped: {
                    currentScreen = .login
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
