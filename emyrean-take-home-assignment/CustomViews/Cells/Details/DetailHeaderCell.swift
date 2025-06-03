//
//  DetailHeaderCell.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import UIKit

protocol DetailHeaderCellDelagate: AnyObject {
    func didTapAvatarButton(user: User)
}

class DetailHeaderCell: UICollectionViewCell {
    
    /// Colletion View Identifer
    static let identifier = "DetailHeaderCell"
    
    weak var delegate: DetailHeaderCellDelagate?
    
    /// Item author
    lazy var authorLabel = EMTitleLabel(textAlignment: .left, fontSize: 14)
    
    /// Avatar image button
    lazy var avatarButton = EMAvatarButton()
    
    /// View container
    lazy var infoContainerView = UIView()
    
    /// item image
    lazy var itemImage = EMItemImageView(frame: .zero)
    
    /// Item title  label
    lazy var itemTitle = EMTitleLabel()
    
    /// Item summary label
    lazy var itemSummary = EMBodyLabel()
    
    
    /// Item and user
    var itemAndUser: ItemAndUser? {
        didSet {
            guard let itemAndUser = itemAndUser else { return }
            authorLabel.text = itemAndUser.user.name
            itemTitle.text = itemAndUser.item.title
            itemSummary.text = itemAndUser.item.summary
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureAvatarButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(avatarButton, authorLabel, infoContainerView)
        infoContainerView.addSubviews(itemImage, itemTitle, itemSummary)
        
        layer.cornerRadius = 16
        backgroundColor = .systemBackground
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            avatarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarButton.widthAnchor.constraint(equalToConstant: 55),
            avatarButton.heightAnchor.constraint(equalToConstant: 55),
            
            authorLabel.leadingAnchor.constraint(equalTo: avatarButton.trailingAnchor, constant: 8),
            authorLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            infoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            infoContainerView.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: padding),
            infoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            itemImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemImage.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: padding),
            itemImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            itemImage.heightAnchor.constraint(equalToConstant: 200),
            
            itemTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemTitle.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: padding),
            itemTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            itemSummary.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemSummary.topAnchor.constraint(equalTo: itemTitle.bottomAnchor, constant: padding),
            itemSummary.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureAvatarButton() {
        avatarButton.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
    }
    
    @objc private func avatarTapped() {
        if let user = itemAndUser?.user {
            delegate?.didTapAvatarButton(user: user)
        }
    }
}
