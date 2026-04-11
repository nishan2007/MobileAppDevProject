//
//  MainFeedView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI
import ParseSwift

enum FeedCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case travel = "Travel"
    case stem = "STEM"
    case gaming = "Gaming"
    case fitness = "Fitness"
    case food = "Food"

    var id: String { rawValue }
}

struct FeedPost: Identifiable {
    let id = UUID()
    let username: String
    let handle: String
    let category: FeedCategory
    let timePosted: String
    let caption: String
    let likes: Int
    let comments: Int
}

struct MainFeedView: View {
    let currentUserName: String
    @State private var selectedCategory: FeedCategory = .all
    
    @State private var posts: [FeedPost] = [
        FeedPost(username: "Ava", handle: "@avaexplores", category: .travel, timePosted: "12m", caption: "Just got back from an amazing beach trip. The sunset was unreal.", likes: 24, comments: 6),
        FeedPost(username: "Leo", handle: "@leostem", category: .stem, timePosted: "28m", caption: "Working on a small SwiftUI project and learning a lot about state management.", likes: 18, comments: 4),
        FeedPost(username: "Mia", handle: "@miaplays", category: .gaming, timePosted: "1h", caption: "Finally beat the level that had me stuck all week.", likes: 31, comments: 9),
        FeedPost(username: "Noah", handle: "@fitnoah", category: .fitness, timePosted: "2h", caption: "Morning workout done. Staying consistent is the hardest part.", likes: 15, comments: 2),
        FeedPost(username: "Ella", handle: "@ellaeats", category: .food, timePosted: "3h", caption: "Tried a new pasta recipe today and it came out so good.", likes: 21, comments: 5)
    ]
    
    private var filteredPosts: [FeedPost] {
        if selectedCategory == .all {
            return posts
        }
        return posts.filter { $0.category == selectedCategory }
    }
    
    private func loadPosts() async {
        do {
            let fetchedPosts = try await Post.query().find()

            let mappedPosts = fetchedPosts.map { post in
                FeedPost(
                    username: post.username ?? "Unknown",
                    handle: "@\((post.username ?? "user").lowercased())",
                    category: FeedCategory(rawValue: post.category ?? "All") ?? .all,
                    timePosted: "now",
                    caption: post.caption ?? "",
                    likes: 0,
                    comments: 0
                )
            }

            posts = mappedPosts
        } catch {
            print("Error loading posts: \(error)")
        }
    }
    
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
                                        selectedCategory = category
                                    }) {
                                        Text(category.rawValue)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(selectedCategory == category ? Color.blue : Color(.systemBackground))
                                            .foregroundStyle(selectedCategory == category ? .white : .primary)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 14) {
                            ForEach(filteredPosts) { post in
                                FeedPostCard(post: post)
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
            await loadPosts()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didCreatePost)) { _ in
            Task {
                await loadPosts()
            }
        }
    }
    
    struct FeedPostCard: View {
        let post: FeedPost
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(Color.blue.opacity(0.18))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(post.username.prefix(1)))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                        )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(post.username)
                                .fontWeight(.bold)
                            Text(post.handle)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(post.timePosted)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(post.category.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.12))
                            .clipShape(Capsule())
                        
                        Text(post.caption)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                HStack(spacing: 20) {
                    Label("\(post.likes)", systemImage: "heart")
                    Label("\(post.comments)", systemImage: "bubble.right")
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    MainFeedView(currentUserName: "Nishan")
}
