//
//  EMError.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/30/25.
//

enum EMError: String, Error {
    case invalidData = "The data received from the server was invalid. Please try again."
    case invalidUrl = "This URL is not valid. Please try again."
    case generalError = "Oops! Something went wrong! Please try again."
    case noInternetConnection = "Please connect to the internet and try again."
    case invalidUsernameOrPassword = "Invalid username or password. Please try again."
    case invalidResponse = "Invalid response from the server. Please try again."
    case unableToFavorite = "There was an error favoriting this. Please try again."
    case unableToRetreiveFavorites = "There was getting your favorites. Please try again."
    case alreadyInFavorites = "You've already favorited this item."
}

