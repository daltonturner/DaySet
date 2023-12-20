//
//  CardView.swift
//  DaySet
//
//  Created by Dalton Turner on 12/11/23.
//

import SwiftUI

struct CardView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(self.event.title)
            Spacer()
            HStack {
                Label(self.event.duration.formatted(.units()), systemImage: "clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
    }
}

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
