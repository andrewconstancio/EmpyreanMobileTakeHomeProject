//
//  PersistentManager.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: ItemAndUser, actionType: PersistanceActionType, completion: @escaping (EMError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retreivedFavorites = favorites
                switch actionType{
                case .add:
                    guard !retreivedFavorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    
                    retreivedFavorites.append(favorite)
                case .remove:
                    retreivedFavorites.removeAll { $0.item.id == favorite.item.id}
                    break
                }
                
                completion(save(favorites: retreivedFavorites))
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func checkIfFavoriteExists(with id: Int, completion: @escaping (Result<Bool, EMError>) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                let exists = favorites.contains { $0.item.id == id }
                completion(.success(exists))
            case .failure:
                completion(.failure(EMError.unableToRetreiveFavorites))
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[ItemAndUser], EMError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([ItemAndUser].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(EMError.unableToRetreiveFavorites))
        }
    }
    
    static func save(favorites: [ItemAndUser]) -> EMError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return EMError.unableToFavorite
        }
    }
}
