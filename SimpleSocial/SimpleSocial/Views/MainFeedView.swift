//
//  MainFeedView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI

struct MainFeedView: View {
    let currentUserName: String
    @StateObject private var viewModel = FeedViewModel()
    @State private var selectedPostForComments: FeedPost?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome, \(currentUserName)")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Choose a category to explore posts.")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(FeedCategory.allCases) { category in
                                    Button(action: {
                                        viewModel.selectedCategory = category
                                    }) {
                                        Text(category.rawValue)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(viewModel.selectedCategory == category ? Color.blue : Color(.systemBackground))
                                            .foregroundStyle(viewModel.selectedCategory == category ? .white : .primary)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }

                        VStack(spacing: 14) {
                            ForEach(viewModel.filteredPosts) { post in
                                FeedPostCard(
                                    post: post,
                                    onLikeTapped: {
                                        viewModel.likePost(post)
                                    },
                                    onCommentTapped: {
                                        selectedPostForComments = post
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Simple Social")
        }
        .task {
            await viewModel.loadPosts()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didCreatePost)) { _ in
            Task {
                await viewModel.loadPosts()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .didCreateComment)) { _ in
            Task {
                await viewModel.loadPosts()
            }
        }
        .sheet(item: $selectedPostForComments) { post in
            CommentsView(post: post)
        }
    }
}

#Preview {
    MainFeedView(currentUserName: "Nishan")
}
