//
//  EventForm.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import SwiftUI

// MARK: -

struct EventFormFeature: Reducer {

    struct State: Equatable {
        @BindingState var event: Event
        @BindingState var focus: Field?

        enum Field: Hashable {
            case title
            case note
        }

        init(focus: Field? = .title, event: Event) {
            self.focus = focus
            self.event = event
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            }
        }
    }
}

// MARK: -

struct EventFormView: View {
    let store: StoreOf<EventFormFeature>
    @FocusState var focus: EventFormFeature.State.Field?

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    TextField("Title", text: viewStore.$event.name)
                        .focused(self.$focus, equals: .title)
                    VStack {
                        Slider(value: viewStore.$event.duration.minutes, in: 1...60, step: 1) {
                            Text("Length")
                        }
                        Text(viewStore.event.duration.formatted(.units()))
                            .font(.title3.weight(.semibold))
                            .multilineTextAlignment(.center)
                    }
                } header: {
                    Text("Event Info")
                }
                Section {
                    Picker("Priority", selection: viewStore.$event.priority) {
                        ForEach(Event.Priority.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(4)
                    TextField("Note", text: viewStore.$event.note)
                        .focused(self.$focus, equals: .note)
                } header: {
                    Text("Additional Info")
                }
            }
            .bind(viewStore.$focus, to: self.$focus)
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            EventFormView(
                store: Store(initialState: EventFormFeature.State(event: .mock)) {
                    EventFormFeature()
                }
            )
        }
    }
}
