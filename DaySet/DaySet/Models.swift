//
//  Models.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import SwiftUI

struct Event: Equatable, Identifiable, Codable {
  let id: UUID
  var duration = Duration.seconds(60 * 5)
  var meetings: [Meeting] = []
  var title = ""
}

struct Meeting: Equatable, Identifiable, Codable {
  let id: UUID
  let date: Date
  var transcript: String
}

extension Event {
  static let mock = Self(
    id: Event.ID(),
    duration: .seconds(60),
    meetings: [
      Meeting(
        id: Meeting.ID(),
        date: Date().addingTimeInterval(-60 * 60 * 24 * 7),
        transcript: """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
          incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
          exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure \
          dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. \
          Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt \
          mollit anim id est laborum.
          """
      )
    ],
    title: "Design"
  )
}
