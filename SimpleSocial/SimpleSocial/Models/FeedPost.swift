//
//  FeedPost.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/11/26.
//

import Foundation

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
