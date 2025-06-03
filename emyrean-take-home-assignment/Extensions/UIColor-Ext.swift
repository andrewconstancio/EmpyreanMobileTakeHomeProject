//
//  UIColor-Ext.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 5/29/25.
//

import Foundation
import UIKit

extension UIColor {
    /// Provide with a desired color for dark and light modes
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}
