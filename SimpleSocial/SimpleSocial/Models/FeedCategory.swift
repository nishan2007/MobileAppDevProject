//
//  FeedCategory.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import Foundation

enum FeedCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case travel = "Travel"
    case stem = "STEM"
    case gaming = "Gaming"
    case fitness = "Fitness"
    case food = "Food"

    var id: String { rawValue }
}
