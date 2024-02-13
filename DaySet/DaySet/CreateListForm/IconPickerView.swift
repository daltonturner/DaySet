//
//  IconPickerView.swift
//  DaySet
//
//  Created by Dalton Turner on 2/12/24.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 18) {
            ForEach(IconPickerOptions.allCases, id: \.self) { icon in
                ZStack {
                    Circle()
                        .foregroundColor(Color(UIColor.tertiarySystemBackground))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color(uiColor: .label))
                }
                .padding(4)
                .overlay(
                    Circle()
                        .stroke(
                            selectedIcon == icon.rawValue ? Color(
                                UIColor.tertiarySystemBackground
                            ) : Color.clear,
                            lineWidth: 2
                        )
                )
                .onTapGesture {
                    selectedIcon = icon.rawValue
                }
            }
        }
    }
}

#Preview {
    IconPickerView(selectedIcon: .constant("list.bullet"))
}
