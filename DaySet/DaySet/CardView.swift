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
        HStack {
            Text(event.title)
            Spacer()
            HStack {
                Label(event.duration.formatted(.units()), systemImage: "clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.callout)
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

#Preview {
    List {
        CardView(event: .mock)
        CardView(event: .mock)
        CardView(event: .mock)
    }
}
