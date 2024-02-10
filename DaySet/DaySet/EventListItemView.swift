//
//  CardView.swift
//  DaySet
//
//  Created by Dalton Turner on 12/11/23.
//

import SwiftUI

struct EventListItemView: View {

    let title: String
    let duration: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(duration)
        }
    }
}

#Preview {
    List {
        EventListItemView(title: "Brush Teeth", duration: "1 min")
        EventListItemView(title: "Brush Teeth", duration: "1 min")
        EventListItemView(title: "Brush Teeth", duration: "1 min")
    }
}
