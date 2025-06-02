//
//  Item.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/31/25.
//

struct ItemAndUser: Codable, Equatable {
    let item: Item
    let user: User
}

struct Item: Codable, Equatable {
    let id: Int
    let title: String
    let summary: String
    let userId: Int
    let image: String
}

struct ItemComment: Codable {
    let id: Int
    let author: String
    let message: String
    let timestamp: String
}
