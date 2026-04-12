//
//  Comment.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/12/26.
//



import Foundation
import ParseSwift

struct Comment: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var postId: String?
    var username: String?
    var text: String?
}
