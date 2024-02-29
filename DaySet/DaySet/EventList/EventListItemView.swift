//
//  CardView.swift
//  DaySet
//
//  Created by Dalton Turner on 12/11/23.
//

import SwiftUI

// MARK: -

extension EventListItemView {
    struct Configuration {
        let duration: String
        let name: String
        let note: String?
        let priority: Event.Priority?
        
        init(
            duration: String,
            name: String,
            note: String? = nil,
            priority: Event.Priority? = nil
        ) {
            self.duration = duration
            self.name = name
            self.note = note
            self.priority = priority
        }
    }
}

// MARK: -

struct EventListItemView: View {

    let config: Configuration

    var body: some View {
        VStack(alignment: .leading) {
            EventInfoView(
                name: config.name,
                duration: config.duration,
                priority: config.priority
            )

            if let note = config.note, !note.isEmpty {
                Text(note)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: -

struct EventInfoView: View {

    let name: String
    let duration: String
    let priority: Event.Priority?

    var body: some View {
        HStack {
            Text(name)
            if let priority = priority {
                EventPriorityView(priority: priority)
                    .padding(.leading, 4)
            }
            Spacer()
            Text(duration)
        }
        .contentShape(Rectangle())
    }
}

// MARK: -

struct EventPriorityView: View {

    let priority: Event.Priority

    var body: some View {
        switch priority {
        case .low:
            Image(systemName: "exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(Color(uiColor: .label))
        case .medium:
            Image(systemName: "exclamationmark.2")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(Color(uiColor: .label))
        case .high:
            Image(systemName: "exclamationmark.3")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(Color(uiColor: .label))
        case .none:
            EmptyView()
        }
    }
}

#Preview {
    List {
        EventListItemView(
            config: .init(
                duration: "1 min",
                name: "Brush Teeth",
                note: "Only floss the teeth you want to keep!",
                priority: .high
            )
        )
    }
}

#Preview {
    List {
        EventListItemView(
            config: .init(
                duration: "1 min",
                name: "Brush Teeth",
                note: "Only floss the teeth you want to keep!",
                priority: Event.Priority.none
            )
        )
    }
}
