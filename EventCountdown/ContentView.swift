//
//  ContentView.swift
//  EventCountdown
//
//  Created by Ila Hur on 12/27/24.
//

import SwiftUI

struct ContentView: View {
    @State var events: [Event] = []
    
    var body: some View {
        NavigationStack {
            List(events.indices, id: \.self) { index in
                NavigationLink {
                    EventForm(events: $events, event: events[index])
                } label: {
                    EventRow(event: events[index])
                }.swipeActions {
                    Button("Delete", systemImage: "trash") {
                        //remove event
                        events.remove(at: index)
                    }.tint(.red)
                }
            }.onAppear {
                events = events.sorted()
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        EventForm(events: $events, event: nil)
                    } label: {
                        Button("Add Event", systemImage: "plus") { }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable var events: [Event] = [
        Event(title: "Test Event 👻", date: Date().addingTimeInterval(60*60*24*7), textColor: .mint),
        Event(title: "Test Event 🐙", date: Date().addingTimeInterval(60*60*24*7*5), textColor: .red)
    ]
    
    ContentView(events: events)
}
