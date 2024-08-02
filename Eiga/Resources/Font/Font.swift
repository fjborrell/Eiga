//
//  Font.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/27/24.
//

import SwiftUI

/// Extension to provide custom font functionality for the Manrope font family.
public extension Font {
    // MARK: - Font Generation
    
    /// Creates a custom Manrope font with the specified size.
    /// - Parameter size: The desired font size.
    /// - Returns: A Font instance with the Manrope font at the specified size.
    static func manrope(_ size: CGFloat) -> Font {
        return Font.custom("Manrope", size: size)
    }
    
    /// Creates a custom Manrope font with the specified size and weight.
    /// - Parameters:
    ///   - size: The desired font size.
    ///   - weight: The desired font weight from the FontWeight enum.
    /// - Returns: A Font instance with the Manrope font at the specified size and weight.
    static func manrope(_ size: CGFloat, _ weight: FontWeight) -> Font {
        return Font.custom("Manrope-\(weight.rawValue)", size: size)
    }
    
    // MARK: - Weight Enumeration
    
    /// Enumeration representing different weights available for the Manrope font.
    enum FontWeight: String {
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case extraLight = "ExtraLight"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
    }
}

