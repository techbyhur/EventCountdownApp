//
//  Event.swift
//  EventCountdown
//
//  Created by Ila Hur on 12/29/24.
//

import Foundation
import SwiftUICore

struct Event: Identifiable, Comparable, Hashable {
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        //compare by date
        return lhs.date < rhs.date
    }
    
    let id: UUID = UUID()
    var title: String
    var date: Date
    var textColor: Color
    
    mutating func update(event: Event) {
        self.title = event.title
        self.date = event.date
        self.textColor = event.textColor
    }
}

extension Array<Event> {
    
    //Calling .sorted() on an array of events returns the events sorted by date (sooner first)
    func sorted(events: [Event]) -> [Event] {
        var sortedEvents = events
        sortedEvents.sort(by: { $0.date.compare($1.date) == .orderedAscending })
        return sortedEvents
    }
}
