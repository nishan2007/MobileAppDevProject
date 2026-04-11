//
//  Post.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var username: String?
    var category: String?
    var caption: String?
    var likes: Int?
    var comments: Int?
    var likedBy: [String]?
    var image: ParseFile?
}
