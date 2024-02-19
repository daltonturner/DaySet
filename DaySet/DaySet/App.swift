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

    @Dependency(\.continuousClock) var clock
    @Dependency(\.dataManager.save) var saveData

    var body: some ReducerOf<Self> {
        Scope(state: \.listHome,action: /Action.listHome) {
            ListHomeFeature()
        }
        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: .eventList(.delegate(action)))):
                switch action {
                case let .eventListUpdated(events):
                    state.listHome.lists[id: events.id] = events
                    return .none
                }
            case .path:
                return .none
            case .listHome:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }

        Reduce { state, _ in
            .run { [lists = state.listHome.lists] _ in
                enum CancelID { case saveDebounce }
                try await withTaskCancellation(id: CancelID.saveDebounce, cancelInFlight: true) {
                    try await self.clock.sleep(for: .seconds(1))
                    try self.saveData(JSONEncoder().encode(lists), .lists)
                }
            }
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

extension URL {
    static let lists = Self.documentsDirectory.appending(component: "lists.json")
}

#Preview {
    AppView(
        store: .init(
            initialState: AppFeature.State(
                listHome: .init()
            )
        ) {
            AppFeature()
                ._printChanges()
        } withDependencies: {
            $0.dataManager = .mock(
                initialData: try? JSONEncoder().encode([EventList.mock])
            )
        }
    )
}

