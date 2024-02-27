//
//  TimeFormatter.swift
//  DaySet
//
//  Created by Dalton Turner on 2/26/24.
//

import ComposableArchitecture
import Foundation

struct TimeFormatter {
    static func formatDuration(_ duration: Duration) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: DateComponents(second: Int(duration.seconds))) ?? ""
    }

    static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    static func totalDuration(of events: IdentifiedArrayOf<Event>) -> Duration {
        return events.reduce(Duration.seconds(0)) { total, event in
            total + event.duration
        }
    }

    static func calculatePrepareByTime(arrivalTime: Date, events: IdentifiedArrayOf<Event>) -> Date {
        let totalDurationInSeconds = totalDuration(of: events).seconds
        let prepareByTime = Calendar.current.date(
            byAdding: .second,
            value: -Int(totalDurationInSeconds),
            to: arrivalTime
        )
        return prepareByTime ?? arrivalTime
    }
}
