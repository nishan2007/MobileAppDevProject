//
//  CreatePostView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI
import ParseSwift

struct CreatePostView: View {
    let currentUserName: String

    @State private var caption: String = ""
    @State private var selectedCategory: FeedCategory = .travel
    @State private var showingSuccessMessage = false

    
    private func publishPost() {
        let trimmedCaption = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCaption.isEmpty else { return }

        var post = Post()
        post.username = currentUserName
        post.category = selectedCategory.rawValue
        post.caption = trimmedCaption

        Task {
            do {
                _ = try await post.save()
                NotificationCenter.default.post(name: .didCreatePost, object: nil)
                caption = ""
                showingSuccessMessage = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showingSuccessMessage = false
                }
            } catch {
                print("Error saving post: \(error)")
            }
        }
    }
    
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 18) {
                    Text("Create a Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Pick a category and share something with the community.")
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)

                        Picker("Category", selection: $selectedCategory) {
                            ForEach(FeedCategory.allCases.filter { $0 != .all }) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption")
                            .font(.headline)

                        TextField("What's on your mind?", text: $caption, axis: .vertical)
                            .lineLimit(5...8)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button(action: publishPost) {
                        Text("Publish Post")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.55 : 1)

                    if showingSuccessMessage {
                        Text("Post published successfully.")
                            .font(.footnote)
                            .foregroundStyle(.green)
                    }

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Create")
        }
    }

 
}

extension Notification.Name {
    static let didCreatePost = Notification.Name("didCreatePost")
}

#Preview {
    CreatePostView(currentUserName: "Nishan")
}
