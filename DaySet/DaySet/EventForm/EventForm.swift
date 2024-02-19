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
                    HStack {
                        Slider(value: viewStore.$event.duration.minutes, in: 1...59, step: 1) {
                            Text("Length")
                        }
                        Spacer()
                        Text(viewStore.event.duration.formatted(.units()))
                    }
                } header: {
                    Text("Event Info")
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
