//
//  AddList.swift
//  DaySet
//
//  Created by Dalton Turner on 1/15/24.
//

import ComposableArchitecture
import SwiftUI

// MARK: -

struct CreateListFormFeature: Reducer {

    struct State: Equatable {
        @BindingState var eventList: EventList
    }

    enum Action : BindableAction {
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

struct CreateListFormView: View {
    let store: StoreOf<CreateListFormFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 12) {
                    TileView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .circular)
                                .fill(viewStore.$eventList.color.wrappedValue)
                                .frame(width: 96, height: 96)
                                .padding()
                            Image(systemName: viewStore.$eventList.icon.wrappedValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(.white)
                                .padding()
                        }
                        TextField("List Name", text: viewStore.$eventList.name, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2)
                            .font(.title2.weight(.semibold))
                            .multilineTextAlignment(.center)
                    }

                    TileView {
                        ColorPickerView(
                            selectedColor: viewStore.$eventList.color
                        )
                    }

                    TileView {
                        IconPickerView(
                            selectedIcon: viewStore.$eventList.icon
                        )
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    CreateListFormView(
        store: Store(
            initialState: CreateListFormFeature.State(eventList: .mock)) {
                CreateListFormFeature()
            }
    )
}
