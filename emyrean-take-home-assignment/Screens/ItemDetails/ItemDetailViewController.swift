//
//  ItemDetailViewController.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/31/25.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    // MARK: Properties
    
    /// API client
    var apiClient: APIClientProtocol
    
    /// Network image downloader
    var networkImage: NetworkImageProtocol
    
    /// Item and user retreived from the API
    var itemAndUser: ItemAndUser
    
    /// Item comment retreived from the API
    var itemComments: [ItemComment] = []
    
    // MARK: UI Components
    
    /// Main collection view to show the items from the API
    private var detailsCollectionView: UICollectionView!
    
    /// Spinner indicator
    let spinner = SpinnerViewController()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .secondarySystemBackground
        tabBarController?.tabBar.isHidden = true
    }
    
    init(itemAndUser: ItemAndUser, apiClient: APIClientProtocol, networkImage: NetworkImageProtocol) {
        self.itemAndUser = itemAndUser
        self.apiClient = apiClient
        self.networkImage = networkImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI components set up
    
    /// Create the flow layout for the item details collection view using UICollectionViewCompositionalLayout
    private func createFlowLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            switch(sectionIndex) {
            case 0:
                return self.createHeaderLayout()
            case 1:
                return self.createCommentLabelLayout()
            case 2:
                return self.createItemCommentsLayout()
            default:
                return nil
            }
        }
        
        return layout
    }
    
    
    /// Create the header view layout for the item details collection view
    private func createHeaderLayout() -> NSCollectionLayoutSection {
        // Size
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.absolute(400)
        )
        // Item
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        return section
    }
    
    /// Create the comment label layout for the item details collection view
    private func createCommentLabelLayout() -> NSCollectionLayoutSection {
        // Size
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(20)
        )
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
    
    /// Create the comments layout for the item details collection view
    private func createItemCommentsLayout() -> NSCollectionLayoutSection {
        // Size
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(150)
        )
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 5

        return section
    }
    
    /// Configure the collection view for the item details
    private func configureCollectionView() {
        detailsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createFlowLayout())
    
        // Add collection view to subview
        view.addSubview(detailsCollectionView)
        detailsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        detailsCollectionView.backgroundColor = .secondarySystemBackground
        
        //Set collection view delegate and datasource
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        
        // Register collection view cells
        detailsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        detailsCollectionView.register(DetailHeaderCell.self, forCellWithReuseIdentifier: DetailHeaderCell.identifier)
        detailsCollectionView.register(DetailInfoCell.self, forCellWithReuseIdentifier: DetailInfoCell.identifier)
        detailsCollectionView.register(DetailCommentLabel.self, forCellWithReuseIdentifier: DetailCommentLabel.identifier)
        detailsCollectionView.register(DetailCommentCell.self, forCellWithReuseIdentifier: DetailCommentCell.identifier)
        
        
        // Set constraints of collection view
        NSLayoutConstraint.activate([
            detailsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Data Fetching
    
    /// Fetch the comment data for the item by the items ID
    private func fetchComments() {
        createSpinnerView()
        apiClient.fetchCommentsForItem(for: itemAndUser.item.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.removeSpinnerView()
                switch result {
                case .success(let comments):
                    self.itemComments = comments
                    self.detailsCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Spinner Management
    
    /// Creates a custom spinner indicator to show loading process
    fileprivate func createSpinnerView() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        self.view.alpha = 0.5
        spinner.didMove(toParent: self)
    }
    
    /// Remove spinner from the view
    fileprivate func removeSpinnerView() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
        self.view.alpha = 1.0
    }
}
