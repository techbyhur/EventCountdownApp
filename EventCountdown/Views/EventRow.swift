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
    
    let event: Event
    
    private let dateFormatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(event.title)
                .foregroundStyle(event.textColor)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(countdownDate)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onReceive(timer) { time in
            handleTimerUpdate()
        }
        .onAppear {
            countdownDate = getRelativeDateString()
        }
    }
    
    private func getRelativeDateString() -> String {
        if (Date() > event.date) {
            return "Event has passed!"
        }
        return dateFormatter.localizedString(for: event.date, relativeTo: Date())
    }
    
    private func handleTimerUpdate() {
        if Date() > event.date {
            timer.upstream.connect().cancel()
            return countdownDate = "Event has passed!"
        }
        if Date() < event.date {
            return countdownDate = getRelativeDateString()
            
        }
    }
}

#Preview {
    @Previewable var event: Event = Event(
        title: "Example Event 👻",
        date: Date().addingTimeInterval(60*60*24*7*5),
        textColor: Color.mint
    )
    EventRow(event: event)
}
