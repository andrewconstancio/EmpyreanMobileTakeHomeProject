//
//  UIView-Ext.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/30/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
