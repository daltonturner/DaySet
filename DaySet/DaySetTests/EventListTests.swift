//
//  DaySetTests.swift
//  DaySetTests
//
//  Created by Dalton Turner on 12/4/23.
//

import ComposableArchitecture
import XCTest
@testable import DaySet

// TODO: - Extract Store creation to a Factory
@MainActor
final class EventListTests: XCTestCase {
    func testAddEvent() async {
        let store = TestStore(initialState: EventListFeature.State()) {
            EventListFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        var event = Event(
            id: UUID(0)
        )

        // Form is presented
        await store.send(.addButtonTapped) {
            $0.addEvent = EventFormFeature.State(event: event)
        }

        // Event information is updated
        event.title = "Shower"
        event.duration = .seconds(600)
        await store.send(.addEvent(.presented(.set(\.$event, event)))) {
            $0.addEvent?.event.title = "Shower"
            $0.addEvent?.event.duration = .seconds(600)
        }

        // Event is added to the list of events
        await store.send(.saveEventButtonTapped) {
            $0.addEvent = nil
            $0.events[0] = Event(
                id: UUID(0),
                duration: .seconds(600),
                title: "Shower"
            )
        }
    }

    func testCancelAddingEvent() async {
        let store = TestStore(initialState: EventListFeature.State()) {
            EventListFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        var event = Event(
            id: UUID(0)
        )

        // Form is presented
        await store.send(.addButtonTapped) {
            $0.addEvent = EventFormFeature.State(event: event)
        }

        // Event is not added to the list of events
        await store.send(.cancelEventButtonTapped) {
            $0.addEvent = nil
        }
    }
}
