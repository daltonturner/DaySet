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
    var title = ""
}

extension Event {
    static let mock = Self(
        id: Event.ID(),
        duration: .seconds(60),
        title: "Brush Teeth"
    )
}
