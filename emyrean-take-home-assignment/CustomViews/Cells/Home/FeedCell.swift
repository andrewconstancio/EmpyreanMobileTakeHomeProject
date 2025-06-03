//
//  ItemCollectionViewCell.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 5/31/25.
//
import UIKit

protocol FeedCellCellDelagate: AnyObject {
    func didTapAvatarButton(user: User)
    func presentAlertMessage(title: String, message: String, buttonTitle: String)
}

class FeedCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    
    var authorLabel = EMTitleLabel(textAlignment: .left, fontSize: 14)
    var itemTitle = EMBodyLabel(textAlignment: .left)
    var avatarButton = EMAvatarButton()
    
    private var favoriteButton = UIButton()
    private var unFavoriteButton = UIButton()
    
    weak var delegate: FeedCellCellDelagate?
    
    var item: ItemAndUser? {
        didSet {
            guard let item = item else { return }
            authorLabel.text = item.user.name
            itemTitle.text = item.item.title
            checkIfFavoriteExists()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureFavoriteButtons()
        configureAvatarButton()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 8
        backgroundColor = .systemBackground
        
        addSubviews(authorLabel, itemTitle, avatarButton, favoriteButton, unFavoriteButton)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitle.translatesAutoresizingMaskIntoConstraints = false
        
        
        let padding: CGFloat = 16
        let favoritesButtonSize: CGFloat = 32
        
        NSLayoutConstraint.activate([
            avatarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarButton.heightAnchor.constraint(equalToConstant: 38),
            avatarButton.widthAnchor.constraint(equalToConstant: 38),
            
            authorLabel.leadingAnchor.constraint(equalTo: avatarButton.trailingAnchor, constant: 8),
            authorLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemTitle.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 2),
            itemTitle.leadingAnchor.constraint(equalTo: avatarButton.trailingAnchor, constant: 8),
            itemTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: itemTitle.bottomAnchor, constant: padding),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            favoriteButton.heightAnchor.constraint(equalToConstant: favoritesButtonSize),
            favoriteButton.widthAnchor.constraint(equalToConstant: favoritesButtonSize),
            
            unFavoriteButton.topAnchor.constraint(equalTo: itemTitle.bottomAnchor, constant: padding),
            unFavoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            unFavoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            unFavoriteButton.heightAnchor.constraint(equalToConstant: favoritesButtonSize),
            unFavoriteButton.widthAnchor.constraint(equalToConstant: favoritesButtonSize)
        ])
    }
    
    private func configureAvatarButton() {
        avatarButton.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
    }
    
    private func configureFavoriteButtons() {
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        unFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.tintColor = .systemRed
        unFavoriteButton.tintColor = .systemRed
        
        unFavoriteButton.isHidden = true
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        unFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        unFavoriteButton.imageView?.contentMode = .scaleAspectFit
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        unFavoriteButton.addTarget(self, action: #selector(unFavoriteTapped), for: .touchUpInside)
    }
    
    func checkIfFavoriteExists() {
        if let itemID = item?.item.id {
            PersistanceManager.checkIfFavoriteExists(with: itemID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let exist):
                    if exist {
                        self.unFavoriteButton.isHidden = false
                        self.favoriteButton.isHidden = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func avatarTapped() {
        if let user = item?.user {
            delegate?.didTapAvatarButton(user: user)
        }
    }
    
    @objc private func favoriteTapped() {
        if let item = item {
            PersistanceManager.updateWith(favorite: item, actionType: .add) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    unFavoriteButton.isHidden = false
                    favoriteButton.isHidden = true
                    self.delegate?.presentAlertMessage(
                        title: "Success! 🎉",
                        message: "You have added this post to your favorites!",
                        buttonTitle: "Sweet"
                    )
                    return
                }
                
                self.delegate?.presentAlertMessage(
                    title: "Error",
                    message: error.rawValue,
                    buttonTitle: "OK"
                )
            }
        }
    }
    
    @objc private func unFavoriteTapped() {
        favoriteButton.isHidden = false
        favoriteButton.isHidden = true
        
        if let item = item {
            PersistanceManager.updateWith(favorite: item, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    unFavoriteButton.isHidden = true
                    favoriteButton.isHidden = false
                    
                    self.delegate?.presentAlertMessage(title: "Removed!", message: "You have removed this post to your favorites.", buttonTitle: "OK")
                    return
                }
                
                self.delegate?.presentAlertMessage(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}
