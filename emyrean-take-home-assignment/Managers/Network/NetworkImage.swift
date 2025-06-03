//
//  NetworkImage.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/2/25.
//

import UIKit

class NetworkImage: NetworkImageProtocol {
    let cache = NSCache<NSString, UIImage>()
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func downloadImage(from urlStringAvatar: String, completed: @escaping (UIImage?) -> ()) {
        let cacheKey = NSString(string: urlStringAvatar)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlStringAvatar) else { return }
        
        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let data = data,
                let image = UIImage(data: data) else {
                completed(nil)
                return
            }
                  
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completed(image)
            }
        }
        
        task.resume()
    }
}

