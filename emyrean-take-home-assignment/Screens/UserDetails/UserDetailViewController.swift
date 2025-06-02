//
//  UserDetailViewController.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: Properties
    
    /// User for details to be displayed
    var user: User
    
    /// API client
    var apiClient: APIClientProtocol
    
    /// Network image downloader
    var networkImage: NetworkImageProtocol
    
    /// Avatar image of user
    lazy var avatarImage = EMAvatarImageView(frame: .zero)
    
    /// Name of user
    lazy var userLabel = EMTitleLabel(textAlignment: .left, fontSize: 14)
    
    /// Email of user
    lazy var emailLabel = EMBodyLabel()
    
    // MARK: Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureAvatarImage()
    }
    
    init(user: User, apiClient: APIClientProtocol, networkImage: NetworkImageProtocol) {
        self.user = user
        self.apiClient = apiClient
        self.networkImage = networkImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI components set up
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(avatarImage, userLabel, emailLabel)
        
        userLabel.text = user.name
        emailLabel.text = user.email
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            avatarImage.widthAnchor.constraint(equalToConstant: 128),
            avatarImage.heightAnchor.constraint(equalToConstant: 128),
            
            userLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),
            userLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            
            emailLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),
            emailLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8)
        ])
    }
    
    /// Fetched the avatar image for the user to be displayed
    private func configureAvatarImage() {
        networkImage.downloadImage(from: user.avatar) { [weak self] image in
            guard let self = self else { return }
            
            if let image = image {
                self.avatarImage.image = image
            }
        }
    }
}
