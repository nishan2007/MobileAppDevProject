//
//  CommentsViewModel.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/12/26.
//


import Foundation
import SwiftUI
import Combine

@MainActor
final class CommentsViewModel: ObservableObject {
    @Published var comments: [FeedComment] = []
    @Published var commentText: String = ""
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    @Published var isSubmitting: Bool = false

    let post: FeedPost

    init(post: FeedPost) {
        self.post = post
    }

    func loadComments() async {
        errorMessage = nil

        do {
            comments = try await CommentService.shared.fetchComments(for: post.id)
        } catch let error as CommentServiceError {
            errorMessage = error.errorDescription
            print("Error loading comments: \(error)")
        } catch {
            errorMessage = "Something went wrong. Try again"
            print("Error loading comments: \(error)")
        }
    }

    func submitComment() {
        guard !isSubmitting else { return }

        errorMessage = nil
        successMessage = nil
        isSubmitting = true

        let currentText = commentText
        let username = AuthService.shared.currentDisplayName()

        Task {
            do {
                _ = try await CommentService.shared.createComment(
                    postId: post.id,
                    username: username,
                    text: currentText
                )

                commentText = ""
                successMessage = "Comment posted."
                NotificationCenter.default.post(name: .didCreateComment, object: nil)
                await loadComments()
            } catch let error as CommentServiceError {
                errorMessage = error.errorDescription
                print("Error posting comment: \(error)")
            } catch {
                errorMessage = "Something went wrong. Try again"
                print("Error posting comment: \(error)")
            }

            isSubmitting = false
        }
    }
}

extension Notification.Name {
    static let didCreateComment = Notification.Name("didCreateComment")
}
