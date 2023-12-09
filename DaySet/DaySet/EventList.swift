//
//  EventList.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import SwiftUI

struct EventListFeature: Reducer {

    struct State: Equatable {
        @PresentationState var addEvent: EventFormFeature.State?
        var events: IdentifiedArrayOf<Event> = []
    }

    enum Action {
        case addButtonTapped
        case addEvent(PresentationAction<EventFormFeature.Action>)
        case cancelEventButtonTapped
        case saveEventButtonTapped
    }

    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addEvent = EventFormFeature.State(
                    event: Event(
                        id: self.uuid()
                    )
                )
                return .none
            case .addEvent:
                return .none
            case .cancelEventButtonTapped:
                state.addEvent = nil
                return .none
            case .saveEventButtonTapped:
                guard let event = state.addEvent?.event else { return .none }
                state.events.append(event)
                state.addEvent = nil
                return .none
            }
        }
        .ifLet(\.$addEvent, action: /Action.addEvent) {
            EventFormFeature()
        }
    }
}

// TODO: - Extract Strings
struct EventListView: View {
    let store: StoreOf<EventListFeature>

    var body: some View {
        WithViewStore(self.store, observe: \.events) { viewStore in
            VStack {
                List {
                    ForEach(viewStore.state) { standup in
                        CardView(event: standup)
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
                .sheet(
                    store: self.store.scope(
                        state: \.$addEvent,
                        action: { .addEvent($0) }
                    )
                ) { store in
                    NavigationStack {
                        EventFormView(store: store)
                            .navigationTitle("New Event")
                            .toolbar {
                                ToolbarItem {
                                    Button("Save") {
                                        viewStore.send(.saveEventButtonTapped)
                                    }
                                }
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel") {
                                        viewStore.send(.cancelEventButtonTapped)
                                    }
                                }
                            }
                    }
            }
            }
        }
    }
}

struct CardView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(self.event.title)
                .font(.headline)
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
                        ._printChanges()
                }
            )
        }
    }
}
