//
//  EventList.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct EventListFeature: Reducer {

    struct State: Equatable {
        @PresentationState var addEvent: EventFormFeature.State?
        @BindingState var arrivalTime: Date = .now
        var events: IdentifiedArrayOf<Event> = []
    }

    enum Action : BindableAction {
        case addButtonTapped
        case addEvent(PresentationAction<EventFormFeature.Action>)
        case binding(BindingAction<State>)
        case cancelEventButtonTapped
        case saveEventButtonTapped
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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                VStack(spacing: 16) {
                    HStack {
                        Text("DaySet")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
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
                    VStack {
                        DatePicker(
                            "Time",
                            selection: viewStore.$arrivalTime,
                            displayedComponents: [.hourAndMinute]
                        )
                        .scaleEffect(1.25)
                        .labelsHidden()

                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Arrive by")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(formatTime(viewStore.arrivalTime))")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(10)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Prepare by")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(formatTime(calculatePrepareByTime(arrivalTime: viewStore.arrivalTime, events: viewStore.events)))")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
                List {
                    if !viewStore.state.events.isEmpty {
                        ForEach(viewStore.state.events) { event in
                            CardView(event: event)
                        }
                        Section {
                            HStack {
                                Text("Total")
                                Spacer()
                                Text(formatDuration(totalDuration(of: viewStore.events)))
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { } label: {
                            Image(systemName: "line.horizontal.3")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
        }
    }
}

private extension EventListView {
    func totalDuration(of events: IdentifiedArrayOf<Event>) -> Duration {
        return events.reduce(Duration.seconds(0)) { total, event in
            total + event.duration
        }
    }

    func formatDuration(_ duration: Duration) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: DateComponents(second: Int(duration.seconds))) ?? ""
    }

    func calculatePrepareByTime(arrivalTime: Date, events: IdentifiedArrayOf<Event>) -> Date {
        let totalDurationInSeconds = totalDuration(of: events).seconds
        let prepareByTime = Calendar.current.date(byAdding: .second, value: -Int(totalDurationInSeconds), to: arrivalTime)
        return prepareByTime ?? arrivalTime
    }

    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            EventListView(
                store: Store(
                    initialState: EventListFeature.State(
                        arrivalTime: .now,
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
