//
//  APIManager.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/29/25.
//

import Foundation
import UIKit

// MARK: - API Client Implementaion

class APIClient: APIClientProtocol {
    
    private var urlSession: URLSession
    private var urlString: String
    
    init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, EMError>) -> Void) {
        
        let loginRequest = LoginRequest(username: username, password: password)
        
        guard let url = URL(string: "\(urlString)/login") else {
            completion(.failure(EMError.generalError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            completion(.failure(EMError.generalError))
        }
         
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(EMError.generalError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(LoginResponse.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(EMError.invalidUsernameOrPassword))
                return
            }
        }
        
        task.resume()
    }
    
    func fetchItems(completion: @escaping (Result<[Item], EMError>) -> Void) {
    
        guard let url = URL(string: "\(urlString)/items") else {
            completion(.failure(EMError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenManager.shared.getAuthToken())", forHTTPHeaderField: "Authorization")
         
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(EMError.generalError))
                return
            }
  
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode([Item].self, from: data)
                completion(.success(results))
            } catch {
                print(error.localizedDescription)
                completion(.failure(EMError.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    func fetchUser(userId: Int, completion: @escaping (Result<User, EMError>) -> Void) {
    
        guard let url = URL(string: "\(urlString)/users/\(userId)") else {
            completion(.failure(EMError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenManager.shared.getAuthToken())", forHTTPHeaderField: "Authorization")
         
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(EMError.invalidData))
                return
            }
  
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(User.self, from: data)
                completion(.success(results))
            } catch {
                print(error.localizedDescription)
                completion(.failure(EMError.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    func fetchItemsAndPosts(completion: @escaping (Result<[ItemAndUser], EMError>) -> Void) {
        self.fetchItems { result in
            switch result {
            case .success(let items):
                var itemsAndUsers: [ItemAndUser] = []
                let dispatchGroup = DispatchGroup()
                
                for item in items {
                    dispatchGroup.enter()
                    self.fetchUser(userId: item.userId) { userResult in
                        switch userResult {
                        case .success(let user):
                            itemsAndUsers.append(ItemAndUser(item: item, user: user))
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(itemsAndUsers))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCommentsForItem(for itemID: Int, completion: @escaping (Result<[ItemComment], EMError>) -> Void) {
    
        guard let url = URL(string: "\(urlString)/items/\(itemID)/comments") else {
            completion(.failure(EMError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenManager.shared.getAuthToken())", forHTTPHeaderField: "Authorization")
         
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(EMError.generalError))
                return
            }
  
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode([ItemComment].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(EMError.invalidData))
                return
            }
        }
        
        task.resume()
    }
}
