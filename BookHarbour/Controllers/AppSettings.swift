//
//  AppSettings.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/12/24.
//

import Foundation
import SwiftUI

class AppSettings {
    static let shared = AppSettings()

    private init() {}

    struct Colors {
        static let primaryColor = Color("PrimaryColor")
        static let secondaryColor = Color("SecondaryColor")
        static let defaultBackgroundColor = Color(hex: "#F8F6F1")
        // Add more colors as needed
    }

    struct Fonts {
        static let titleFont = Font.custom("TitleFont", size: 24)
        static let bodyFont = Font.custom("BodyFont", size: 16)
        // Add more fonts as needed
    }
}

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: opacity
        )
    }
}
