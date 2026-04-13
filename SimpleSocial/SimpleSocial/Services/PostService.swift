//
//  PostService.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/11/26.
//

import Foundation
import ParseSwift

enum PostServiceError: LocalizedError {
    case emptyCaption
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .emptyCaption:
            return "Please enter a caption before posting."
        case .unknown(let message):
            return message
        }
    }
}

final class PostService {
    static let shared = PostService()

    private init() {}

    func createPost(username: String, category: FeedCategory, caption: String, imageData: Data?) async throws -> Post {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCaption = caption.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedCaption.isEmpty else {
            throw PostServiceError.emptyCaption
        }

        var post = Post()
        post.username = trimmedUsername.isEmpty ? "User" : trimmedUsername
        post.category = category.rawValue
        post.caption = trimmedCaption
        post.likes = 0
        post.comments = 0
        post.likedBy = []

        if let imageData {
            post.image = ParseFile(name: "post.jpg", data: imageData)
        }

        do {
            return try await post.save()
        } catch let error as ParseError {
            throw PostServiceError.unknown(error.localizedDescription)
        } catch {
            throw PostServiceError.unknown("Unable to publish post right now.")
        }
    }

    // Fetches ALL posts (for the main feed)
    func fetchPosts() async throws -> [FeedPost] {
        do {
            let currentUsername = AuthService.shared.currentDisplayName().trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let fetchedPosts = try await Post.query()
                .order([.descending("createdAt")])
                .find()

            return fetchedPosts.map { post in
                FeedPost(
                    id: post.objectId ?? UUID().uuidString,
                    username: post.username ?? "Unknown",
                    handle: "@\((post.username ?? "user").lowercased())",
                    category: FeedCategory(rawValue: post.category ?? "All") ?? .all,
                    timePosted: relativeTimeString(from: post.createdAt),
                    caption: post.caption ?? "",
                    likes: post.likes ?? 0,
                    comments: post.comments ?? 0,
                    imageURL: post.image?.url,
                    isLikedByCurrentUser: (post.likedBy ?? []).contains(currentUsername)
                )
            }
        } catch let error as ParseError {
            throw PostServiceError.unknown(error.localizedDescription)
        } catch {
            throw PostServiceError.unknown("Unable to load posts right now.")
        }
    }
    
    // ADDED: Fetches ONLY posts by a specific user (for the Profile View)
    func fetchPosts(for targetUsername: String) async throws -> [FeedPost] {
        do {
            let currentUsername = AuthService.shared.currentDisplayName().trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            // The query now includes a constraint: "username" == targetUsername
            let fetchedPosts = try await Post.query("username" == targetUsername)
                .order([.descending("createdAt")])
                .find()

            return fetchedPosts.map { post in
                FeedPost(
                    id: post.objectId ?? UUID().uuidString,
                    username: post.username ?? "Unknown",
                    handle: "@\((post.username ?? "user").lowercased())",
                    category: FeedCategory(rawValue: post.category ?? "All") ?? .all,
                    timePosted: relativeTimeString(from: post.createdAt),
                    caption: post.caption ?? "",
                    likes: post.likes ?? 0,
                    comments: post.comments ?? 0,
                    imageURL: post.image?.url,
                    isLikedByCurrentUser: (post.likedBy ?? []).contains(currentUsername)
                )
            }
        } catch let error as ParseError {
            throw PostServiceError.unknown(error.localizedDescription)
        } catch {
            throw PostServiceError.unknown("Unable to load posts for this user right now.")
        }
    }

    func toggleLike(postId: String, username: String) async throws -> Bool {
        do {
            let normalizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let results = try await Post.query("objectId" == postId).find()
            guard var post = results.first else {
                throw PostServiceError.unknown("Post not found.")
            }

            var likedBy = post.likedBy ?? []
            let wasLiked = likedBy.contains(normalizedUsername)

            if wasLiked {
                likedBy.removeAll { $0 == normalizedUsername }
                post.likes = max((post.likes ?? 0) - 1, 0)
            } else {
                likedBy.append(normalizedUsername)
                post.likes = (post.likes ?? 0) + 1
            }

            post.likedBy = likedBy
            _ = try await post.save()
            return !wasLiked
        } catch let error as ParseError {
            throw PostServiceError.unknown(error.localizedDescription)
        } catch let error as PostServiceError {
            throw error
        } catch {
            throw PostServiceError.unknown("Unable to update like right now.")
        }
    }

    private func relativeTimeString(from date: Date?) -> String {
        guard let date = date else { return "now" }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
