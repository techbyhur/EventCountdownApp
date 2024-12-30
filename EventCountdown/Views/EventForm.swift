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
    @State var event: Event?
    
    let onSave: (Event) -> Void
    
    init(event: Event?, onSave: @escaping (Event) -> Void) {
        _event = State(initialValue: event)
        self.onSave = onSave
        initialize(event: event)
    }
    
    var body: some View {
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
                    saveEvent(Event(title: eventTitle, date: eventDate, textColor: eventTextColor))
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
    
    private func saveEvent(_ event: Event) {
        switch mode {
        case .newEvent: onSave(event)
        case .editEvent: do {
            self.event!.update(event: event)
            onSave(self.event!)
        }}
    }
}

#Preview {
    @Previewable var event: Event? = Event(title: "Test Event 👻", date: Date().addingTimeInterval(60*60*24*7), textColor: .mint)
    @Previewable var emptyEvent: Event? = nil
    var events: [Event] = []
    EventForm(event: emptyEvent) { event in
        events.append(event)
    }
}
