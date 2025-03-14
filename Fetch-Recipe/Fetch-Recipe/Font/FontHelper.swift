//
//  FontHelper.swift
//  WeatherApp
//
//  Created by Abhishek Dogra on 17/01/25.
//

import Foundation
import SwiftUI

enum FontSize {
    case size70
    case size60
    case size30
    case size28
    case size22
    case size18
    case size14
    case size12
    
    var size: CGFloat {
        switch self {
        case .size70: return 70
        case .size60: return 60
        case .size30: return 30
        case .size28: return 28
        case .size22: return 22
        case .size18: return 18
        case .size14: return 14
        case .size12: return 12
        }
    }
}

struct PoppinsFont {
    enum Weight: String {
        case thin100 = "Poppins-Thin"
        case extraLight200 = "Poppins-ExtraLight"
        case light300 = "Poppins-Light"
        case regular400 = "Poppins-Regular"
        case medium500 = "Poppins-Medium"
        case semiBold600 = "Poppins-SemiBold"
        case bold700 = "Poppins-Bold"
        case extraBold800 = "Poppins-ExtraBold"
        case black900 = "Poppins-Black"
    }

    static func custom(_ weight: Weight, size: FontSize) -> Font {
        return Font.custom(weight.rawValue, size: size.size)
    }
}


struct PoppinsTextModifier: ViewModifier {
    var weight: PoppinsFont.Weight
    var size: FontSize
    
    func body(content: Content) -> some View {
        content.font(PoppinsFont.custom(weight, size: size))
    }
}

extension View {
    func font(weight: PoppinsFont.Weight, size: FontSize) -> some View {
        self.modifier(PoppinsTextModifier(weight: weight, size: size))
    }
}
