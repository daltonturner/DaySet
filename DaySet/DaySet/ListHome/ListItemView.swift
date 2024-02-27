//
//  ListItemView.swift
//  DaySet
//
//  Created by Dalton Turner on 2/26/24.
//

import SwiftUI

struct ListItemView: View {

    let list: EventList

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .fill(list.color)
                    .frame(width: 36, height: 36)
                Image(systemName: list.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
            }
            .padding(.top, 2)
            .padding(.bottom, 2)
            Text(list.name)
        }
    }
}
