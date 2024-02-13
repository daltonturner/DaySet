//
//  TileView.swift
//  DaySet
//
//  Created by Dalton Turner on 2/12/24.
//

import SwiftUI

struct TileView<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    TileView {
        Text("Hello World")
    }
}
