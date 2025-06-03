//
//  EmAvatarButton.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import UIKit

class EMAvatarButton: UIButton {
    let placeholderImage = UIImage(systemName: "person.circle")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
        setImage(placeholderImage, for: .normal)
    }
}

