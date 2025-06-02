//
//  NetworkImageProtocol.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/2/25.
//
import UIKit

protocol NetworkImageProtocol {
    func downloadImage(from urlStringAvatar: String, completed: @escaping (UIImage?) -> ())
}

