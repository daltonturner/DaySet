//
//  Color+Codable.swift
//  DaySet
//
//  Created by Dalton Turner on 1/15/24.
//

import SwiftUI

extension Color: Codable {

    // Encodes the Color instance to an Encoder.
    public func encode(to encoder: Encoder) throws {
        // Convert the Color to a UIColor (for iOS) or NSColor (for macOS), then to RGBA.
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // Encode the RGBA values.
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .alpha)
    }

    // Decodes a Color instance from a Decoder.
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let red = try values.decode(CGFloat.self, forKey: .red)
        let green = try values.decode(CGFloat.self, forKey: .green)
        let blue = try values.decode(CGFloat.self, forKey: .blue)
        let alpha = try values.decode(CGFloat.self, forKey: .alpha)
        
        // Initialize the Color using the decoded RGBA values.
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    // Define the keys used for encoding/decoding.
    enum CodingKeys: CodingKey {
        case red, green, blue, alpha
    }
}

// UIColor extension to convert Color to UIColor. This is needed for iOS.
#if canImport(UIKit)
import UIKit
extension UIColor {
    convenience init(_ color: Color) {
        let cgColor = color.cgColor
        self.init(cgColor: cgColor!)
    }
}
#endif
