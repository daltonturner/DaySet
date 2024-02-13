//
//  EmptyEventListView.swift
//  DaySet
//
//  Created by Dalton Turner on 2/6/24.
//

import SwiftUI

struct EmptyEventListView: View {

    @State private var animationsRunning = false

    private enum Strings {
        static let emptyEventListTitle: String = "Nothing here"
        static let emptyEventListBody: String = "Add some new events to get started"
    }

    let title: String
    let bodyText: String

    init(
        title: String = Strings.emptyEventListTitle,
        bodyText: String = Strings.emptyEventListBody
    ) {
        self.title = title
        self.bodyText = bodyText
    }

    var body: some View {
        VStack {
            Button("Start transition") {
                withAnimation {
                    animationsRunning.toggle()
                }
            }
            VStack(spacing: 12) {
                Image(systemName: "list.bullet")
                    .symbolEffect(.bounce.byLayer, value: animationsRunning)
                    .font(.system(size: 48))
                    .padding(6)
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(bodyText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(10)
        }
    }
}

#Preview {
    EmptyEventListView()
}
