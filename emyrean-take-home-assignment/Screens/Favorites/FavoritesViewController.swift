//
//  FavoritesViewController.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/31/25.
//
import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: Properties
    
    /// API client
    var apiClient: APIClientProtocol
    
    /// Favorites table view
    let tableView = UITableView()
    
    /// favorited items
    var favorites: [ItemAndUser] = []
    
    /// Network image downloader
    var networkImage: NetworkImageProtocol
    
    /// No favorites view container
    private var noFavoritesView = EMEmptyStateView()
    
    /// No favorites label
    private let noFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "No Favorites!\n Go favorite some items on the home screen"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .dynamicColor(light: .black, dark: .lightGray)
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(apiClient: APIClientProtocol, networkImage: NetworkImageProtocol) {
        self.apiClient = apiClient
        self.networkImage = networkImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
        configureTableView()
        configureNavBar()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: UI components set up
    
    /// Configures the main table view
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
    }
    
    /// Configures the main navigation bar
    private func configureNavBar() {
        // Add the Home label to the navigation bar
        let logoLabel = UILabel()
        logoLabel.text = "Favorites"
        logoLabel.font = .systemFont(ofSize: 25, weight: .black)
        logoLabel.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: logoLabel)
    }
    
    // MARK: Data Fetching

    /// Fetches the favorited items saved into user defaults
    func getFavorites() {
        PersistanceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch(result) {
            case .success(let favorites):
                
                if favorites.isEmpty {
                    showNoFavoritesView()
                    return
//                    self.presentAlertOnMainThread(title: "No Favorites!", message: "Go add favorite some items on the home screen", buttonTitle: "Ok")
                }
                
                hideNoFavoritesView()
                
                self.favorites = favorites
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func showNoFavoritesView() {
        noFavoritesView.addSubview(noFavoritesLabel)

        NSLayoutConstraint.activate([
            noFavoritesLabel.centerXAnchor.constraint(equalTo: noFavoritesView.centerXAnchor),
            noFavoritesLabel.centerYAnchor.constraint(equalTo: noFavoritesView.centerYAnchor),
        ])
        
        tableView.backgroundView = noFavoritesView
    }
    
    func hideNoFavoritesView() {
        tableView.backgroundView = nil
    }
}
