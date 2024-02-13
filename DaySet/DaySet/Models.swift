//
//  Models.swift
//  DaySet
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import SwiftUI

struct EventList: Equatable, Identifiable, Codable {
    let id: UUID
    var color = Color.red
    var events: IdentifiedArrayOf<Event> = []
    var icon = "list.bullet"
    var name = ""
}

extension EventList {
    static let mock = Self(
        id: EventList.ID(),
        events: [.mock],
        name: "Morning Routine"
    )
}

struct Event: Equatable, Identifiable, Codable {
    let id: UUID
    var duration = Duration.seconds(60)
    var title = ""
}

extension Event {
    static let mock = Self(
        id: Event.ID(),
        duration: .seconds(60),
        title: "Brush Teeth"
    )
}
