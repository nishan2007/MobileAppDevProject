//
//  CommentService.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/12/26.
//



import Foundation
import ParseSwift

enum CommentServiceError: LocalizedError {
    case emptyComment
    case invalidPost
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .emptyComment:
            return "Please enter a comment before posting."
        case .invalidPost:
            return "This post could not be found."
        case .unknown(let message):
            return message
        }
    }
}

final class CommentService {
    static let shared = CommentService()

    private init() {}

    func createComment(postId: String, username: String, text: String) async throws -> Comment {
        let trimmedPostId = postId.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPostId.isEmpty else {
            throw CommentServiceError.invalidPost
        }

        guard !trimmedText.isEmpty else {
            throw CommentServiceError.emptyComment
        }

        var comment = Comment()
        comment.postId = trimmedPostId
        comment.username = trimmedUsername.isEmpty ? "User" : trimmedUsername
        comment.text = trimmedText

        do {
            let savedComment = try await comment.save()
            try await updatePostCommentCount(postId: trimmedPostId, change: 1)
            return savedComment
        } catch let error as ParseError {
            throw CommentServiceError.unknown(error.localizedDescription)
        } catch let error as CommentServiceError {
            throw error
        } catch {
            throw CommentServiceError.unknown("Unable to post comment right now.")
        }
    }

    func fetchComments(for postId: String) async throws -> [FeedComment] {
        let trimmedPostId = postId.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPostId.isEmpty else {
            throw CommentServiceError.invalidPost
        }

        do {
            let fetchedComments = try await Comment.query("postId" == trimmedPostId)
                .order([.descending("createdAt")])
                .find()

            return fetchedComments.map { comment in
                let username = comment.username ?? "Unknown"
                return FeedComment(
                    id: comment.objectId ?? UUID().uuidString,
                    username: username,
                    handle: "@\(username.lowercased())",
                    text: comment.text ?? "",
                    timePosted: relativeTimeString(from: comment.createdAt)
                )
            }
        } catch let error as ParseError {
            throw CommentServiceError.unknown(error.localizedDescription)
        } catch {
            throw CommentServiceError.unknown("Unable to load comments right now.")
        }
    }

    private func updatePostCommentCount(postId: String, change: Int) async throws {
        let posts = try await Post.query("objectId" == postId).find()
        guard var post = posts.first else {
            throw CommentServiceError.invalidPost
        }

        let currentCount = post.comments ?? 0
        post.comments = max(currentCount + change, 0)
        _ = try await post.save()
    }

    private func relativeTimeString(from date: Date?) -> String {
        guard let date = date else { return "now" }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
