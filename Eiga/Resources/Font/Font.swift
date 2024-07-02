//
//  Font.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/27/24.
//

import SwiftUI

public extension Font {
    static func manrope(_ size: CGFloat) -> Font {
        return Font.custom("Manrope", size: size)
    }
    
    static func manrope(_ size: CGFloat, _ weight: FontWeight) -> Font {
        return Font.custom("Manrope-\(weight.rawValue)", size: size)
    }
    
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


