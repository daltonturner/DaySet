//
//  ColorPickerView.swift
//  DaySet
//
//  Created by Dalton Turner on 2/12/24.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
            ForEach(ColorPickerOptions.allCases, id: \.self) { color in
                Circle()
                    .fill(color.color)
                    .frame(width: 32, height: 32)
                    .padding(4)
                    .overlay(
                        Circle()
                            .stroke(
                                selectedColor == color.color ? color.color : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .onTapGesture {
                        selectedColor = color.color
                    }
            }
        }
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.red))
}
