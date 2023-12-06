//
//  EventList.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import SwiftUI

struct EventListFeature: Reducer {

    struct State {
        var events: IdentifiedArrayOf<Event> = []
    }

    enum Action {
        case addButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.events.append(
                    Event(
                        id: UUID()
                    )
                )
                return .none
            }
        }
    }
}

// TODO: - Extract Strings
struct EventListView: View {
    let store: StoreOf<EventListFeature>

    var body: some View {
        WithViewStore(self.store, observe: \.events) { viewStore in
            List {
                ForEach(viewStore.state) { standup in
                    CardView(standup: standup)
                }
            }
            .navigationTitle("DaySet")
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        viewStore.send(.addButtonTapped)
                    }
                }
            }
        }
    }
}

struct CardView: View {
    let standup: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(self.standup.title)
                .font(.headline)
            Spacer()
            HStack {
                Label(self.standup.duration.formatted(.units()), systemImage: "clock")
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

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            EventListView(
                store: Store(
                    initialState: EventListFeature.State(
                        events: [.mock]
                    )
                ) {
                    EventListFeature()
                }
            )
        }
    }
}
