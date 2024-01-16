//
//  AddList.swift
//  DaySet
//
//  Created by Dalton Turner on 1/15/24.
//

import ComposableArchitecture
import SwiftUI

struct AddListFeature: Reducer {

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

struct AddListView: View {
    let store: StoreOf<AddListFeature>

    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .brown, .white, .gray, .black, .mint]
    let icons: [String] = ["list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "book", "calendar", "person", "gear", "house", "cart", "phone"]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack {
                    TileView {
                        ZStack {
                            Circle()
                                .fill(viewStore.$eventList.color.wrappedValue)
                                .frame(height: 120)
                                .padding()
                            Image(systemName: viewStore.$eventList.icon.wrappedValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .padding()
                        }
                        TextField("List Name", text: viewStore.$eventList.name)
                            .textFieldStyle(.roundedBorder)
                    }

                    TileView {
                        ColorPickerView(selectedColor: viewStore.$eventList.color, colors: colors)
                    }

                    TileView {
                        IconPickerView(selectedIcon: viewStore.$eventList.icon, icons: icons)
                    }
                }
                .padding()
            }
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    let colors: [Color]

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 30, height: 30)
                    .padding(3)
                    .overlay(
                        Circle()
                            .stroke(selectedColor == color ? color : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

struct IconPickerView: View {
    @Binding var selectedIcon: String
    let icons: [String]

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
            ForEach(icons, id: \.self) { icon in
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(selectedIcon == icon ? .blue : .primary)
                    .onTapGesture {
                        selectedIcon = icon
                    }
            }
        }
    }
}

struct TileView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    AddListView(
        store: Store(
            initialState: AddListFeature.State(eventList: .mock)) {
                AddListFeature()
            }
    )
}
