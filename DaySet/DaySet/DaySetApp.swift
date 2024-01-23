//
//  DaySetApp.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct DaySetApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: AppFeature.State()
                ) {
                    AppFeature()
                        ._printChanges()
                }
            )
        }
    }
}
