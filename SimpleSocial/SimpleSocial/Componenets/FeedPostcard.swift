//
//  Postcard.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI

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

#Preview {
    FeedPostCard(
        post: FeedPost(
            username: "Nishan",
            handle: "@nishan",
            category: .stem,
            timePosted: "now",
            caption: "This is a sample post card preview.",
            likes: 12,
            comments: 3
        )
    )
    .padding()
}
