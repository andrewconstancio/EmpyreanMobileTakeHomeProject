//
//  EMTextField.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/29/25.
//

import UIKit

class EMTextField: UITextField {
    
    private let textPadding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String, isSecureTextEntry: Bool = false) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemIndigo.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .done
        clearButtonMode = .whileEditing
        autocapitalizationType = UITextAutocapitalizationType.none
        placeholder = self.placeholder
        isSecureTextEntry = self.isSecureTextEntry
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
