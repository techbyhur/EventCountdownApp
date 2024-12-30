//
//  EventForm.swift
//  EventCountdown
//
//  Created by Ila Hur on 12/29/24.
//
// Referred to https://www.hackingwithswift.com/books/ios-swiftui/using-an-alert-to-pop-a-navigationlink-programmatically
// tutorial for Cancel dialog
//

import SwiftUI

enum Mode {
    case editEvent
    case newEvent
}

struct EventForm: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var showingCancelAlert = false
    @State var mode: Mode = .newEvent
    @State var eventTitle: String = ""
    @State var eventDate: Date = Date()
    @State var eventTextColor: Color = Color.black
    
    @Binding var events: [Event]
    @State var event: Event?
    
    init(events: Binding<[Event]>, event: Event?) {
        _events = events
        _event = State(initialValue: event)
        initialize(event: event)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Details") {
                    TextField("Title",text: $eventTitle, prompt: Text("Title"))
                    DatePicker("Date", selection: $eventDate, in: .now...)
                    ColorPicker("Text Color", selection: $eventTextColor)
                }
            }
            .navigationTitle(getNavTitle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save Event", systemImage: "checkmark") {
                        onSave(Event(title: eventTitle,date: eventDate,textColor: eventTextColor))
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(eventTitle.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if (shouldShowCancelDialog()) {
                            showingCancelAlert = true
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }.alert("Are you sure?", isPresented: $showingCancelAlert) {
                Button("Yes", role: .destructive) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                Button("No", role: .cancel) { }
            } message: {
                Text("You have unsaved changes. Are you sure you want to cancel?")
            }
        }
    }
    
    private func getNavTitle() -> String {
        return if mode == .editEvent { "Edit \(self.event!.title)" } else { "Add Event" }
    }
    
    private mutating func initialize(event: Event?) {
        if event == nil {
            self._mode = State(initialValue: .newEvent)
        } else {
            self._mode = State(initialValue: .editEvent)
            self._eventTitle = State(initialValue: event!.title)
            self._eventDate = State(initialValue: event!.date)
            self._eventTextColor = State(initialValue: event!.textColor)
        }
    }
    
    private func shouldShowCancelDialog() -> Bool {
        return switch mode {
        case .newEvent: !eventTitle.isEmpty
        case .editEvent: eventTitle != event!.title || eventDate != event!.date || eventTextColor != event!.textColor
        }
    }
    
    private func onSave(_ event: Event) -> Void {
        print("event details: \(event.title)")
        switch mode {
        case .newEvent: self._events.wrappedValue.append(event)
        case .editEvent: updateEvent(event)
        }
    }
    
    private func updateEvent(_ event: Event) {
        guard let index = self._events.wrappedValue.firstIndex(
            where: { $0.id == self.event!.id }
        ) else {
            return
        }
        self.event!.update(event: event)
        self._events.wrappedValue[index] = self.event!
    }
}

#Preview {
    @Previewable @State var events: [Event] = []
    @Previewable var event: Event? = Event(title: "Test Event 👻", date: Date().addingTimeInterval(60*60*24*7), textColor: .mint)
    @Previewable var emptyEvent: Event? = nil
    EventForm(events: $events, event: emptyEvent)
}
