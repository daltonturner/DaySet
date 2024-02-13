//
//  PickerColors.swift
//  DaySet
//
//  Created by Dalton Turner on 2/12/24.
//

import SwiftUI

enum ColorPickerOptions: CaseIterable {
    case red, orange, yellow, green, blue, purple, pink, brown, cyan, gray, teal, mint

    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        case .brown: return .brown
        case .cyan: return .cyan
        case .gray: return .gray
        case .teal: return .teal
        case .mint: return .mint
        }
    }
}
