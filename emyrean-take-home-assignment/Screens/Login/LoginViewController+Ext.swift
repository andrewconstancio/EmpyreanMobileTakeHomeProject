//
//  LoginViewController+Ext.swift
//  empyrean-mobile-take-home-assignment
//
//  Created by Andrew Constancio on 5/29/25.
//

import UIKit

// MARK: - Keyboard Handling Extension for LoginViewController

extension LoginViewController {
    
    /// Registers observers for keyboard hide/show notifications
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    /// Moves the view up when the keyboard is showing
    @objc func keyBoardWillShow(notifcation: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        
        if keyboardIsHidden {
            view.frame.origin.y = -80
        }
    }
    
    /// Resets the view to the original position when the keyboard goes away
    @objc func keyBoardWillHide(notifcation: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        if !keyboardIsHidden {
            view.frame.origin.y = 0
        }
    }
    
    /// Hides the keyboard when the tapping outside of it
    @objc func hideKeyboardWhenTappedAround() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// Dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

