//
//  EMTabBarController.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/30/25.
//

import UIKit

class EMTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearence()
        self.viewControllers = [createHomeNavigationController(), createFavoritesNavigationController()]
    }
    
    func createHomeNavigationController() -> UINavigationController {
        let homeViewController = HomeViewController(
            apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared),
            networkImage: NetworkImage(urlSession: URLSession.shared)
        )
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: .init(systemName: "house.fill"), tag: 0)
        
        return UINavigationController(rootViewController: homeViewController)
    }
    
    func createFavoritesNavigationController() -> UINavigationController {
        let favoriteViewController = FavoritesViewController(
            apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared),
            networkImage: NetworkImage(urlSession: URLSession.shared)
        )
        favoriteViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        return UINavigationController(rootViewController: favoriteViewController)
    }
    
    private func configureTabBarAppearence() {
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .systemIndigo
    }
}

