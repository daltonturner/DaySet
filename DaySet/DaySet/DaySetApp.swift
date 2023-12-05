//
//  DaySetApp.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import SwiftUI

import ComposableArchitecture
import SwiftUI

@main
struct DaySetApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        EventListView(
          store: Store(
            initialState: EventListFeature.State()
          ) {
              EventListFeature()
          }
        )
      }
    }
  }
}
