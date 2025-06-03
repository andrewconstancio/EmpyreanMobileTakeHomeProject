//
//  APIClientProtocol.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//
import UIKit

// MARK: -  Protocol Definition

protocol APIClientProtocol {
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, EMError>) -> Void)
    func fetchItems(completion: @escaping (Result<[Item], EMError>) -> Void)
    func fetchUser(userId: Int, completion: @escaping (Result<User, EMError>) -> Void)
    func fetchItemsAndPosts(completion: @escaping (Result<[ItemAndUser], EMError>) -> Void)
    func fetchCommentsForItem(for itemID: Int, completion: @escaping (Result<[ItemComment], EMError>) -> Void)
}
