//
//  FavoriteCell.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/2/25.
//

import UIKit

protocol FavoriteCellDelegate: AnyObject {
    func didTapAvatarButton(user: User)
}

class FavoriteCell: UITableViewCell {
    
    static let identifier = "FavoriteCell"
    
    private var authorLabel = EMTitleLabel(textAlignment: .left, fontSize: 14)
    
    private var itemTitle = EMBodyLabel(textAlignment: .left)
    
    var avatarButton = EMAvatarButton()
    
    weak var delegate: FavoriteCellDelegate?
    
    var item: ItemAndUser? {
        didSet {
            guard let item = item else { return }
            authorLabel.text = item.user.name
            itemTitle.text = item.item.title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureAvatarButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(authorLabel)
        contentView.addSubview(itemTitle)
        contentView.addSubview(avatarButton)
        
        let padding: CGFloat = 12
        
        avatarButton.bringSubviewToFront(self)
        
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
            itemTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func configureAvatarButton() {
        avatarButton.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
    }
    
    @objc private func avatarTapped() {
        if let user = item?.user {
            delegate?.didTapAvatarButton(user: user)
        }
    }
}
