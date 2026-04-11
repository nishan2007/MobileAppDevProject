//
//  AuthService.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/11/26.
//

import Foundation
import ParseSwift

enum AuthServiceError: LocalizedError {
    case invalidUsername
    case invalidEmail
    case invalidPassword
    case passwordsDoNotMatch
    case incorrectCredentials
    case sessionExpired
    case noCurrentUser
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidUsername:
            return "Please enter a username."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPassword:
            return "Password must be at least 6 characters."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        case .incorrectCredentials:
            return "Incorrect username or password."
        case .sessionExpired:
            return "Session expired. Please log in again."
        case .noCurrentUser:
            return "No user is currently logged in."
        case .unknown(let message):
            return message
        }
    }
}

final class AuthService {
    static let shared = AuthService()

    private init() {}

    func signUp(username: String, email: String, password: String, confirmPassword: String) async throws -> User {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUsername.isEmpty else {
            throw AuthServiceError.invalidUsername
        }

        guard !trimmedEmail.isEmpty, trimmedEmail.contains("@"), trimmedEmail.contains(".") else {
            throw AuthServiceError.invalidEmail
        }

        guard password.count >= 6 else {
            throw AuthServiceError.invalidPassword
        }

        guard password == confirmPassword else {
            throw AuthServiceError.passwordsDoNotMatch
        }

        var newUser = User()
        newUser.username = trimmedUsername
        newUser.email = trimmedEmail
        newUser.password = password

        do {
            return try await newUser.signup()
        } catch let error as ParseError {
            throw mapParseError(error)
        } catch {
            throw AuthServiceError.unknown("Unable to create account right now.")
        }
    }

    func login(username: String, password: String) async throws -> User {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUsername.isEmpty else {
            throw AuthServiceError.invalidUsername
        }

        guard !password.isEmpty else {
            throw AuthServiceError.invalidPassword
        }

        do {
            return try await User.login(username: trimmedUsername, password: password)
        } catch let error as ParseError {
            throw mapParseError(error)
        } catch {
            throw AuthServiceError.unknown("Unable to log in right now.")
        }
    }

    func logout() async throws {
        guard User.current != nil else {
            throw AuthServiceError.noCurrentUser
        }

        do {
            try await User.logout()
        } catch let error as ParseError {
            throw mapParseError(error)
        } catch {
            throw AuthServiceError.unknown("Unable to log out right now.")
        }
    }

    func currentUsername() -> String? {
        User.current?.username
    }

    func isLoggedIn() -> Bool {
        User.current != nil
    }

    func currentDisplayName() -> String {
        User.current?.username ?? "User"
    }

    private func mapParseError(_ error: ParseError) -> AuthServiceError {
        switch error.code {
        case .objectNotFound:
            return .incorrectCredentials
        case .invalidSessionToken:
            return .sessionExpired
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
