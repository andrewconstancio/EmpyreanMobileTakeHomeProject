//
//  DetailCommentLabel.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import UIKit

class DetailCommentLabel: UICollectionViewCell {
    
    static let identifier = "DetailCommentLabel"
    
    lazy var commentLabel = EMTitleLabel(textAlignment: .left, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(commentLabel)
        
        commentLabel.text = "Comments"
        
        NSLayoutConstraint.activate([
            commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}


