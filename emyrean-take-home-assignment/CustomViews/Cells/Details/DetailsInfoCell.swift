//
//  DetailsInfoCell.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import UIKit


class DetailInfoCell: UICollectionViewCell {
    
    static let identifier = "DetailInfoCell"
    
    /// View container
    lazy var containerView = UIView()
    
    /// item image
    lazy var itemImage = EMItemImageView(frame: .zero)
    
    /// Item title
    lazy var itemTitle = EMTitleLabel()
    
    /// Item summary
    lazy var itemSummary = EMBodyLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        containerView.addSubviews(itemImage, itemTitle, itemSummary)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            itemImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemImage.topAnchor.constraint(equalTo: topAnchor),
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
    
    func set(item: Item) {
        itemTitle.text = item.title
        itemSummary.text = item.summary
    }
}

