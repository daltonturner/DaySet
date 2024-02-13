//
//  ListHomeView.swift
//  DaySet
//
//  Created by Dalton Turner on 1/16/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct ListHomeFeature: Reducer {

    struct State: Equatable {
        @PresentationState var addList: CreateListFormFeature.State?
        var lists: IdentifiedArrayOf<EventList> = []
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

struct ListHomeView: View {
    let store: StoreOf<ListHomeFeature>

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
                .padding(.horizontal)
                List {
                    if !viewStore.state.lists.isEmpty {
                        ForEach(viewStore.state.lists) { list in
                            NavigationLink(
                                state: AppFeature.Path.State.eventList(EventListFeature.State(events: list.events))
                            ) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(list.color)
                                            .frame(height: 40)
                                            .padding()
                                        Image(systemName: list.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                    Text(list.name)
                                }
                            }
                        }
                        .onDelete { indices in
                            viewStore.send(.deleteList(indices: indices))
                        }
                    }
                }
                .toolbar {
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
