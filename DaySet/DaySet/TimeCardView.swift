//
//  TimeCardView.swift
//  DaySet
//
//  Created by Dalton Turner on 2/6/24.
//

import SwiftUI

struct TimeCardView: View {

    let cardTitle: String
    let cardTime: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(cardTitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(cardTime)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    TimeCardView(
        cardTitle: "Arrive by",
        cardTime: "10:00 PM"
    )
}
