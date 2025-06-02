//
//  EMEmptyStateView.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/30/25.
//

import UIKit

class EMEmptyStateView: UIView {
    
    let messageLabel = EMTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        self.messageLabel.text = message
    }
    
    private func configure() {
        configureMessageLabel()
//        configureLogoImageView()
    }
    
    private func configureMessageLabel() {
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
//        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant)
//        messageLabelCenterYConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
//    private func configureLogoImageView() {
//        addSubview(logoImageView)
//        
//        logoImageView.image = Images.emptyStateImage
//        logoImageView.translatesAutoresizingMaskIntoConstraints = false
//    
//        
//        let logoImageViewBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80  : 100
//        let logoImageViewBottomConstaint = logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoImageViewBottomConstant)
//        logoImageViewBottomConstaint.isActive = true
//        
//        NSLayoutConstraint.activate([
//            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
//            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
//            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 200)
//        ])
//    }
}

