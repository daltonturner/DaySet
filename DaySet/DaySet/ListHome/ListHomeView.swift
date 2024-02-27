//
//  ListHomeView.swift
//  DaySet
//
//  Created by Dalton Turner on 1/16/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

// MARK: -

struct ListHomeFeature: Reducer {

    struct State: Equatable {
        @PresentationState var addList: CreateListFormFeature.State?
        var lists: IdentifiedArrayOf<EventList> = []

        init(addList: CreateListFormFeature.State? = nil) {
            self.addList = addList
            do {
                @Dependency(\.dataManager.load) var loadData
                self.lists = try
                JSONDecoder().decode(
                    IdentifiedArrayOf<EventList>.self,
                    from: loadData(.lists)
                )
            } catch {
                self.lists = []
            }
        }
    }

    enum Action {
        case addButtonTapped
        case addList(PresentationAction<CreateListFormFeature.Action>)
        case cancelListButtonTapped
        case deleteList(indices: IndexSet)
        case saveListButtonTapped
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addList = CreateListFormFeature.State(
                    eventList: EventList(
                        id: self.uuid()
                    )
                )
                return .none
            case .addList:
                return .none
            case .cancelListButtonTapped:
                state.addList = nil
                return .none
            case .deleteList(let indices):
                state.lists.remove(atOffsets: indices)
                return .none
            case .saveListButtonTapped:
                guard let list = state.addList?.eventList else { return .none }
                state.lists.append(list)
                state.addList = nil
                return .none
            }
        }
        .ifLet(\.$addList, action: /Action.addList) {
            CreateListFormFeature()
        }
    }
}

// MARK: -

struct ListHomeView: View {
    let store: StoreOf<ListHomeFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if !viewStore.lists.isEmpty {
                    listSection(viewStore: viewStore)
                }
            }
            .navigationTitle("Home")
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
                    state: \.$addList,
                    action: { .addList($0) }
                )
            ) { store in
                NavigationStack {
                    CreateListFormView(store: store)
                        .navigationTitle("New List")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem {
                                Button("Save") {
                                    viewStore.send(.saveListButtonTapped)
                                }
                                .disabled(viewStore.addList?.eventList.name.isEmpty ?? true)
                            }
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    viewStore.send(.cancelListButtonTapped)
                                }
                            }
                        }
                }
            }
        }
    }
}

@MainActor @ViewBuilder
func listSection(
    viewStore: ViewStore<ListHomeFeature.State, ListHomeFeature.Action>
) -> some View {
    List {
        Section {
            ForEach(viewStore.state.lists) { list in
                NavigationLink(
                    state: AppFeature.Path.State.eventList(EventListFeature.State(eventList: list))
                ) {
                    ListItemView(list: list)
                }
            }
            .onDelete { indices in
                viewStore.send(.deleteList(indices: indices))
            }
        } header: {
            Text("My Lists")
        }
        .headerProminence(.increased)
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            ListHomeView(
                store: Store(
                    initialState: ListHomeFeature.State()
                ) {
                    ListHomeFeature()
                        ._printChanges()
                }
            )
        }
    }
}
