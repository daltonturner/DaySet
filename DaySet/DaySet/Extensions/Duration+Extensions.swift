//
//  Duration+Extensions.swift
//  DaySet
//
//  Created by Dalton Turner on 12/11/23.
//

extension Duration {

    var seconds: Double {
        get { Double(self.components.seconds) }
        set { self = .seconds(newValue) }
    }

    var minutes: Double {
        get { Double(self.components.seconds / 60) }
        set { self = .seconds(newValue * 60) }
    }

    var hours: Double {
        get { Double(self.components.seconds / 3600) }
        set { self = .seconds(newValue * 3600) }
    }

    var days: Double {
        get { Double(self.components.seconds / (3600 * 24)) }
        set { self = .seconds(newValue * 3600 * 24) }
    }

    var weeks: Double {
        get { Double(self.components.seconds / (3600 * 24 * 7)) }
        set { self = .seconds(newValue * 3600 * 24 * 7) }
    }

}
