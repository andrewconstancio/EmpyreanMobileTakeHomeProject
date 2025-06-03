//
//  Login.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/2/25.
//
import UIKit

struct LoginRequest: Encodable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
    let user: LoggedInUser
}

struct LoggedInUser: Codable {
    let id: Int
    let name: String
}


