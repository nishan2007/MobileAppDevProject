//
//  SimpleSocialApp.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI
import ParseSwift
@main
struct SimpleSocialApp: App {
    
    init() {
        ParseSwift.initialize(
            applicationId: "eFGyU9J6x5KZLCw9UvT6SOBEHjoWh5bx9rml1N9L",
            clientKey: "R6sj6I0nUt6F7pArrX8iwiUa8nvSlFPDbxiAoGSg",
            serverURL: URL(string: "https://parseapi.back4app.com")!
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
