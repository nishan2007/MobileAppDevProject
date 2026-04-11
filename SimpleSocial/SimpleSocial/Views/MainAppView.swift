//
//  MainAppView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import Foundation
import SwiftUI

struct MainAppView: View {
    let currentUserName: String
    let onLogoutTapped: () -> Void

    var body: some View {
        TabView {
            MainFeedView(currentUserName: currentUserName)
                .tabItem {
                    Label("Feed", systemImage: "house.fill")
                }

            CreatePostView(currentUserName: currentUserName)
                .tabItem {
                    Label("Create", systemImage: "square.and.pencil")
                }

            ProfileView(
                currentUserName: currentUserName,
                onLogoutTapped: onLogoutTapped
            )
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

#Preview {
    MainAppView(
        currentUserName: "Nishan",
        onLogoutTapped: {}
    )
}
