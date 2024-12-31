//
//  EventRow.swift
//  EventCountdown
//
//  Created by Ila Hur on 12/29/24.
//
//  Referred to Timer tutorial from https://www.hackingwithswift.com/books/ios-swiftui/counting-down-with-a-timer
//

import SwiftUI

struct EventRow: View {
    @State var countdownDate: String = ""
    @State private var now = Date.now
    
    let event: Event
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(event.title)
                .foregroundStyle(event.textColor)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(getCountdownDate(for: event.date, relativeTo: now))
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onReceive(timer) { date in
                    now = date
                }
        }
    }
    
    private func getCountdownDate(for date: Date, relativeTo currentDate: Date) -> String {
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.dateTimeStyle = .named
        return dateFormatter.localizedString(for: date, relativeTo: currentDate)
    }
}

#Preview {
    @Previewable var event: Event = Event(
        title: "Example Event 👻",
        date: Date().addingTimeInterval(60*60*24*7),
        textColor: Color.mint
    )
    EventRow(event: event)
}
