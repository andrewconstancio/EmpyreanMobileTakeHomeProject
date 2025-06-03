//
//  HomeViewController.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 5/31/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    /// API client
    var apiClient: APIClientProtocol
    
    /// Network image downloader
    var networkImage: NetworkImageProtocol
    
    /// Items retreived from the API
    var itemAndUser: [ItemAndUser] = []
    
    var feedFetchError: Error?
    
    // MARK: UI Components
    
    /// Main collection view to show the items from the API
    var feedCollectionView: UICollectionView!
    
    /// Spinner indicator
    let spinner = SpinnerViewController()
    
    /// Pull to refresh control on the collectionview
    let refreshControl = UIRefreshControl()
    
    /// No internet collection view container
    private var noInternetConnectionView = EMEmptyStateView()
    
    /// No Internet label
    private let noConnectionLabel: UILabel = {
        let label = UILabel()
        label.text = "You're offline\nPlease check your connection and refresh"
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
        configureNavBar()
        configureCollectionView()
        createSpinnerView()
        fetchItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedCollectionView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    init(apiClient: APIClientProtocol, networkImage: NetworkImageProtocol) {
        self.apiClient = apiClient
        self.networkImage = networkImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI components set up
    
    private func configureNavBar() {
        // Add the Home label to the navigation bar
        let logoLabel = UILabel()
        logoLabel.text = "Home"
        logoLabel.font = .systemFont(ofSize: 25, weight: .black)
        logoLabel.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: logoLabel)
        
        // ADd the sign out button to the navigation bar
        let signOutButton = UIButton()
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.label, for: .normal)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOutButton)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Add collection view to subview
        view.addSubview(feedCollectionView)
        feedCollectionView.showsVerticalScrollIndicator = false
        feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //Set collection view delegate and datasource
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        // Register collection view cells
        feedCollectionView.register(FeedErrorCell.self, forCellWithReuseIdentifier: FeedErrorCell.identifier)
        feedCollectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        feedCollectionView.refreshControl = refreshControl
        
        // Add target to refresh control
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        // Set constraints of collection view
        NSLayoutConstraint.activate([
            feedCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Data Fetching
    
    /// Fetch the items from the API and reloads the collection view
    private func fetchItems() {
        feedFetchError = nil
        
        // Check network connection
        guard NetworkMonitor.shared.isConnected else {
            endRefreshing()
            showNoInternetView()
            return
        }
        
        feedCollectionView.backgroundColor = .systemBackground
        
        hideNoInternetView()
        
        apiClient.fetchItemsAndPosts { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.endRefreshing()

                switch result {
                case .success(let items):
                    self.itemAndUser = items
                    self.feedCollectionView.backgroundColor = .secondarySystemBackground
                    self.feedCollectionView.reloadData()
                case .failure(let error):
                    self.feedFetchError = error
                    self.feedCollectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: UI Actions set up
    
    /// Signing out the user removed the auth token from the keychain and navigates to the login view
    @objc private func signOut() {
        TokenManager.shared.deleteAuthToken()
        navigateToLoginView()
    }
    
    /// When logging out this make the login view controller the root view controller
    private func navigateToLoginView() {
        let loginVC = LoginViewController(apiClient: APIClient(urlString: EMConstants.baseURL, urlSession: URLSession.shared))
        let navController = UINavigationController(rootViewController: loginVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    /// Handles pulling down on the collection view and refreshing
    @objc private func handleRefresh() {
        DispatchQueue.main.async {
            self.feedCollectionView.reloadData()
        }
        fetchItems()
    }
    
    /// Ends refreshing the fetched items
    private func endRefreshing() {
        removeSpinnerView()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Spinner Management
    
    /// Creates a custom spinner indicator to show loading process
    fileprivate func createSpinnerView() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    /// Remove spinner from the view
    fileprivate func removeSpinnerView() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    // MARK: - Error/Empty States
    
    /// This displays the no internet view
    func showNoInternetView() {
        refreshControl.endRefreshing()
        noInternetConnectionView.addSubview(noConnectionLabel)

        NSLayoutConstraint.activate([
            noConnectionLabel.centerXAnchor.constraint(equalTo: noInternetConnectionView.centerXAnchor),
            noConnectionLabel.centerYAnchor.constraint(equalTo: noInternetConnectionView.centerYAnchor),
        ])
        
        feedCollectionView.backgroundView = noInternetConnectionView
    }
    
    /// Hide the no internet view
    func hideNoInternetView() {
        feedCollectionView.backgroundView = nil
    }
}
