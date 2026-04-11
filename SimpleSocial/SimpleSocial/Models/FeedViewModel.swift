//
//  FeedViewModel.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/11/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var selectedCategory: FeedCategory = .all
    @Published var errorMessage: String? = nil
    @Published var posts: [FeedPost] = []

    private var likingPostIDs: Set<String> = []

    var filteredPosts: [FeedPost] {
        if selectedCategory == .all {
            return posts
        }
        return posts.filter { $0.category == selectedCategory }
    }

    func loadPosts() async {
        errorMessage = nil

        do {
            posts = try await PostService.shared.fetchPosts()
        } catch let error as PostServiceError {
            errorMessage = error.errorDescription
            print("Error loading posts: \(error)")
        } catch {
            errorMessage = "Something went wrong. Try again"
            print("Error loading posts: \(error)")
        }
    }

    func likePost(_ post: FeedPost) {
        guard !likingPostIDs.contains(post.id) else { return }

        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        let originalLikes = posts[index].likes
        let originalLikedState = posts[index].isLikedByCurrentUser

        posts[index].isLikedByCurrentUser.toggle()
        posts[index].likes += posts[index].isLikedByCurrentUser ? 1 : -1
        posts[index].likes = max(posts[index].likes, 0)

        likingPostIDs.insert(post.id)
        errorMessage = nil

        Task {
            do {
                let username = AuthService.shared.currentDisplayName()
                let isLiked = try await PostService.shared.toggleLike(postId: post.id, username: username)

                if let updatedIndex = posts.firstIndex(where: { $0.id == post.id }) {
                    posts[updatedIndex].isLikedByCurrentUser = isLiked
                }
            } catch let error as PostServiceError {
                if let rollbackIndex = posts.firstIndex(where: { $0.id == post.id }) {
                    posts[rollbackIndex].likes = originalLikes
                    posts[rollbackIndex].isLikedByCurrentUser = originalLikedState
                }
                errorMessage = error.errorDescription
                print("Error liking post: \(error)")
            } catch {
                if let rollbackIndex = posts.firstIndex(where: { $0.id == post.id }) {
                    posts[rollbackIndex].likes = originalLikes
                    posts[rollbackIndex].isLikedByCurrentUser = originalLikedState
                }
                errorMessage = "Something went wrong. Try again"
                print("Error liking post: \(error)")
            }

            likingPostIDs.remove(post.id)
        }
    }
}
