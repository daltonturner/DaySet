//
//  EventList.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

// MARK: -

struct EventListFeature: Reducer {

    struct State: Equatable {
        @PresentationState var addEvent: EventFormFeature.State?
        @BindingState var arrivalTime: Date = .now
        var eventList: EventList
    }

    enum Action: BindableAction {
        case addButtonTapped
        case addEvent(PresentationAction<EventFormFeature.Action>)
        case binding(BindingAction<State>)
        case cancelEventButtonTapped
        case delegate(Delegate)
        case deleteEvent(indices: IndexSet)
        case saveEventButtonTapped

        enum Delegate {
            case eventListUpdated(EventList)
        }
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        BindingReducer()
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
            case .binding(_):
                return .none
            case .cancelEventButtonTapped:
                state.addEvent = nil
                return .none
            case .delegate:
                return .none
            case .deleteEvent(let indices):
                state.eventList.events.remove(atOffsets: indices)
                return .none
            case .saveEventButtonTapped:
                guard let event = state.addEvent?.event else { return .none }
                state.eventList.events.append(event)
                state.addEvent = nil
                return .none
            }
        }
        .ifLet(\.$addEvent, action: /Action.addEvent) {
            EventFormFeature()
        }
        .onChange(of: \.eventList) { oldValue, newValue in
            Reduce { state, action in
                return .send(.delegate(.eventListUpdated(newValue)))
            }
        }
    }
}

// MARK: -

struct EventListView: View {
    let store: StoreOf<EventListFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if !viewStore.eventList.events.isEmpty {
                    eventListSection(viewStore: viewStore)
                } else {
                    ContentUnavailableView {
                        Label("Nothing here", systemImage: "list.bullet")
                    } description: {
                        Text("Add some events to get started")
                    }
                }
            }
            .animation(.easeInOut)
            .navigationTitle("\(viewStore.state.eventList.name)")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewStore.send(.addButtonTapped) }) {
                        Image(systemName: "plus")
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
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem {
                                Button("Save") {
                                    viewStore.send(.saveEventButtonTapped)
                                }
                                .disabled(viewStore.addEvent?.event.name.isEmpty ?? true)
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

@MainActor @ViewBuilder
private func eventListSection(
    viewStore: ViewStore<EventListFeature.State, EventListFeature.Action>
) -> some View {
    EventListHeaderView(
        arrivalTime: "\(TimeFormatter.formatTime(viewStore.arrivalTime))",
        arrivalTimeBinding: viewStore.$arrivalTime,
        getReadyTime: "\(TimeFormatter.formatTime(TimeFormatter.calculatePrepareByTime(arrivalTime: viewStore.arrivalTime, events: viewStore.eventList.events)))"
    )
    .padding()
    List {
        Section {
            ForEach(viewStore.state.eventList.events) { event in
                EventListItemView(
                    config: .init(
                        duration: "\(event.duration.formatted(.units()))",
                        name: "\(event.name)",
                        note: "\(event.note)",
                        priority: event.priority
                    )
                )
            }
            .onDelete { indices in
                viewStore.send(.deleteEvent(indices: indices))
            }
        } header: {
            Text("Tasks")
        }
        .headerProminence(.increased)
        Section {
            EventListItemView(
                config: .init(
                    duration: "\(TimeFormatter.totalDuration(of: viewStore.eventList.events).formatted(.units()))",
                    name: "Total"
                )
            )
        }
    }
}

// MARK: -

struct EventListHeaderView: View {

    let arrivalTime: String
    let arrivalTimeBinding: Binding<Date>
    let getReadyTime: String

    var body: some View {
        VStack(spacing: 18) {
            DatePicker(
                "Time",
                selection: arrivalTimeBinding,
                displayedComponents: [.hourAndMinute]
            )
            .scaleEffect(1.25)
            .labelsHidden()
            HStack(spacing: 18) {
                TimeCardView(
                    cardTitle: "Arrive by",
                    cardTime: arrivalTime
                )
                TimeCardView(
                    cardTitle: "Get ready",
                    cardTime: getReadyTime
                )
            }
        }
    }
}

// MARK: -

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            EventListView(
                store: Store(
                    initialState: EventListFeature.State(
                        arrivalTime: .now,
                        eventList: .mock
                    )
                ) {
                    EventListFeature()
                        ._printChanges()
                }
            )
        }
    }
}
