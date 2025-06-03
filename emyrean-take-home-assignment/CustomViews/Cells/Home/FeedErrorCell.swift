//
//  FeedErrorCell.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//

import UIKit

class FeedErrorCell: UICollectionViewCell {

    static let identifier = "FeedErrorCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.text = "Oops! Something went wrong.\n Please pull to refresh."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        addSubview(errorMessageLabel)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
