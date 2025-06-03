//
//  TokenManager.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 5/30/25.
//
import Foundation

class TokenManager {
    
    static let shared = TokenManager()
    private init() {}
    
    private let serviceName: String = "com.kuma.emyrean-take-home-assignment"
    private let accountName: String = "jwt-token"
    
    func saveAuthToken(_ token: String) throws {
        do {
            try KeychainManager.shared.save(
               service: serviceName,
               account: accountName,
               token: token.data(using: .utf8) ?? Data()
           )
        } catch {
            throw error
        }
    }
    
    func checkAuthTokenExists() -> Bool {
        KeychainManager.shared.get(
            service: serviceName,
            account: accountName
        ) != nil
    }
    
    func deleteAuthToken() {
        KeychainManager.shared.delete(
            service: serviceName,
            account: accountName
        )
    }
    
    func getAuthToken() -> String {
        if let data = KeychainManager.shared.get(service: serviceName, account: accountName), let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return ""
    }
}
