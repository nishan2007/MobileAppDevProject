//
//  CommentsRowView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/12/26.
//



import SwiftUI

struct CommentsRowView: View {
    let comment: FeedComment

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.18))
                .frame(width: 42, height: 42)
                .overlay(
                    Text(String(comment.username.prefix(1)))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                )

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(comment.username)
                        .fontWeight(.semibold)
                    Text(comment.handle)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(comment.timePosted)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    CommentsRowView(
        comment: FeedComment(
            id: "preview-comment",
            username: "Nishan",
            handle: "@nishan",
            text: "This is a preview comment.",
            timePosted: "now"
        )
    )
    .padding()
}
