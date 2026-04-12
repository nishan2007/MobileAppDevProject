//
//  CommentsView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/12/26.
//



import SwiftUI

struct CommentsView: View {
    let post: FeedPost
    @StateObject private var viewModel: CommentsViewModel

    init(post: FeedPost) {
        self.post = post
        _viewModel = StateObject(wrappedValue: CommentsViewModel(post: post))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(post.username)
                                    .font(.headline)
                                Text(post.caption)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                            .padding(.top)

                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                                    .padding(.horizontal)
                            }

                            if let successMessage = viewModel.successMessage {
                                Text(successMessage)
                                    .font(.footnote)
                                    .foregroundStyle(.green)
                                    .padding(.horizontal)
                            }

                            if viewModel.comments.isEmpty {
                                Text("No comments yet. Be the first to comment.")
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(viewModel.comments) { comment in
                                        CommentsRowView(comment: comment)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                        }
                    }

                    VStack(spacing: 10) {
                        TextField("Write a comment...", text: $viewModel.commentText, axis: .vertical)
                            .lineLimit(2...4)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        Button(action: viewModel.submitComment) {
                            Text(viewModel.isSubmitting ? "Posting..." : "Post Comment")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(viewModel.isSubmitting || viewModel.commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity((viewModel.isSubmitting || viewModel.commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? 0.55 : 1)
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Comments")
        }
        .task {
            await viewModel.loadComments()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didCreateComment)) { _ in
            Task {
                await viewModel.loadComments()
            }
        }
    }
}

#Preview {
    CommentsView(
        post: FeedPost(
            id: "preview-post",
            username: "Nishan",
            handle: "@nishan",
            category: .stem,
            timePosted: "now",
            caption: "Preview post caption",
            likes: 3,
            comments: 1,
            imageURL: nil,
            isLikedByCurrentUser: false
        )
    )
}
