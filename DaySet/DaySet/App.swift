//
//  App.swift
//  DaySet
//
//  Created by Dalton Turner on 1/22/24.
//

import ComposableArchitecture
import SwiftUI

struct AppFeature: Reducer {

    struct State {
        var path = StackState<Path.State>()
        var listHome = ListHomeFeature.State()
    }

    @CasePathable
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case listHome(ListHomeFeature.Action)
    }

    struct Path: Reducer {
        enum State {
            case eventList(EventListFeature.State)
        }
        enum Action {
            case eventList(EventListFeature.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: /State.eventList, action: /Action.eventList) {
                EventListFeature()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.listHome,action: /Action.listHome) {
            ListHomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .path(_):
                return .none
            case .listHome(_):
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: { .path($0) })
        ) {
            ListHomeView(
                store: self.store.scope(
                    state: \.listHome,
                    action: \.listHome
                )
            )
        } destination: { state in
            switch state {
            case .eventList:
                CaseLet(
                    /AppFeature.Path.State.eventList,
                     action: AppFeature.Path.Action.eventList,
                     then: EventListView.init(store:)
                )
            }
        }
    }
}

#Preview {
    AppView(
        store: .init(
            initialState: AppFeature.State(
                listHome: .init(lists: [.mock])
            )
        ) {
            AppFeature()
                ._printChanges()
        }
    )
}

