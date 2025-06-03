//
//  EMAvatarImage.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/31/25.
//

import UIKit

class EMAvatarImageView: UIImageView {
    let placeholderImage = UIImage(systemName: "person.circle")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:  NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 8
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
