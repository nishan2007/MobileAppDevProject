//
//  FeedPost.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/11/26.
//

import Foundation

struct FeedPost: Identifiable {
    let id: String
    let username: String
    let handle: String
    let category: FeedCategory
    let timePosted: String
    let caption: String
    var likes: Int
    let comments: Int
    let imageURL: URL?
    var isLikedByCurrentUser: Bool
}
