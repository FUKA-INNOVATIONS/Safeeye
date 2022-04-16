//
//  CreateEventViewModel.swift
//  Safeye
//
//  Created by FUKA on 1.4.2022.
//  Edited by FUKA on 11.4

import Foundation
import SwiftUI

class EventViewModel: ObservableObject {
    static let shared = EventViewModel() ;  private init() {}
    let eventService = EventService.shared
    @State var authUID = AuthenticationService.getInstance.currentUser!.uid
    private var appState = Store.shared
    
    @Published var eventDetails: Event?
    @Published var eventExists = false
    @Published var didCreateEvent = false
    @Published var eventError: String = ""
    @Published var panicMode = false
    @Published var mode = "Tracking"
    
    @StateObject private var notificationService = NotificationService()
    
    // User presses panic mode
    func activatePanicMode() {
        print("Panic Mode activated")
        mode = "Panic"
        
        // TODO Panic Mode functionality #41 -> activate panic mode
    }
    
    // User pressed the safe button -> disabling panic mode
    func disablePanicMode() {
        print("Disabled panic mode")
        mode = "Tracking"
        
        // TODO Panic Mode functionality #41 -> disable panic mode
    }
    // Send notification about panic mode
    func sentNotification() {
        notificationService.createLocalNotification(title: "Safeye: Pavlo", body: "Panic mode activated") { error in
            print("error")
        }
        print("Notification sent")
    }
    
    // User Pressed to disable tracking mode
    func disableTrackingMode() {
        print("Disabled tracking mode")
        
    }
    
    
    func createEvent(_ startDate: Date, _ endDate: Date, otherInfo: String, eventType: String ) -> Bool {
        
        if self.appState.eventSelctedContacts.isEmpty { print("You must select atlest 1 contact") ; return false }
        
        let selectedContactIDS = appState.eventSelctedContacts.map { $0.userId }
        
        // TODO: MAX 5 contacts : firbase way to
        
        self.getEventCurrentUser()
        if self.appState.eventCurrentUser != nil {  print("Current user has an event so new event was not created") ; return false }
        
        print("SELECTED IDS: \(selectedContactIDS)")
        
       @State var coordinates: [String : Double] = ["longitude": Double(12334324), "latitude": Double(454545)]
        
        let newEvent = Event(ownerId: authUID, status: EventStatus.STARTED, startTime: startDate, endTime: endDate, otherInfo: otherInfo, eventType: eventType, trustedContacts: selectedContactIDS, coordinates: coordinates)
        
        let didCreateEvent = eventService.createEvent(newEvent)
        didCreateEvent ? print("EventVM -> New event succeeded") : print("EventVM -> New event failed")
        return didCreateEvent
        //return false
    } // end of createEvent()
    
    
    
    // Get details for a specific event
    func getDetails(for eventID: String) {
        DispatchQueue.main.async {
            self.eventDetails =  self.eventService.getEvent(eventID)
        }
    }
    
    func updateEvent(_ event: Event) {
        self.eventService.updateEvent(event)
    }
    
    func getEventCurrentUser() {
        let currentUserId = AuthenticationService.getInstance.currentUser!.uid
        self.eventService.fetchEventForCurrentUser(userID: currentUserId)
    }
    

    
    func changeStatus(_ eventID: String,_ newStatus: EventStatus) {
        if newStatus == EventStatus.PANIC {  DispatchQueue.main.async { self.panicMode = true  } }
        eventService.changeStatus(eventID, newStatus)
    }
    
    func editEvent() {}
    
    func deleteEvent() {}
    
    func subscribeContact() {}
    
    func unsubscribeContact() {}
    
    // func getLocation() {}
    
    func setLocation() {}
    
    func startListening() {}
    
    
    
}
