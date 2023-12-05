//
//  EventForm.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import SwiftUI

struct EventFormFeature: Reducer {
  struct State: Equatable {
    @BindingState var focus: Field?
    @BindingState var event: Event

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

struct EventFormView: View {
  let store: StoreOf<EventFormFeature>
  @FocusState var focus: EventFormFeature.State.Field?

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section {
          TextField("Title", text: viewStore.$event.title)
            .focused(self.$focus, equals: .title)
          HStack {
            Slider(value: viewStore.$event.duration.minutes, in: 5...30, step: 1) {
              Text("Length")
            }
            Spacer()
            Text(viewStore.event.duration.formatted(.units()))
          }
        } header: {
          Text("event Info")
        }
      }
      .bind(viewStore.$focus, to: self.$focus)
    }
  }
}

extension Duration {
  fileprivate var minutes: Double {
    get { Double(self.components.seconds / 60) }
    set { self = .seconds(newValue * 60) }
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

