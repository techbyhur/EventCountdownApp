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
            List(events, id: \.self) { event in
                NavigationLink(value: event) {
                    EventRow(event: event)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash") {
                        //remove event
                        events.removeAll(where: { $0 == event })
                    }.tint(.red)
                }
            }
            .navigationDestination(for: Event.self) { event in
                EventForm(event: event) { e in
                    guard let index = events.firstIndex(
                        where: { $0.id == e.id }
                    ) else { return }
                    events[index] = e
                }
            }
            .onAppear {
                events = events.sorted()
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        EventForm(event: nil) { e in
                            events.append(e)
                        }
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
