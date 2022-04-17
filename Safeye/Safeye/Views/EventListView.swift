//
//  EventListView.swift
//  Safeye
//
//  Created by FUKA on 17.4.2022.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var EventVM: EventViewModel
    @EnvironmentObject var appState: Store
    
    var body: some View {
        VStack {
            Text("\(EventVM.getEventsCount()) events")
            NavigationLink("Create new event") { CreateEventView() }
            Form {
                Section(header: Text("Events")) {
                    ForEach(appState.eventsOfCurrentUser) { event in
                            NavigationLink {
                                EventView(eventID: event.id!)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                HStack {
                                    Text("\(event.eventType.capitalizingFirstLetter())")
                                        .foregroundStyle(.red)
                                    Text("\(event.startTime.formatted(.dateTime))")
                                        .font(.caption)
                                        
                                    Spacer()
                                    HStack {
                                        Text("\(event.trustedContacts.count)")
                                        Image(systemName: "eye")
                                    }
                                }
                            }
                    }
                }
                 
                 Section(header: Text("Your friend's events")) {
                     
                     ForEach(appState.eventsOfTrustedContacts) { event in
                         NavigationLink {
                             EventView(eventID: event.id!)
                         } label: {
                             HStack {
                                 Text("\(event.eventType.capitalizingFirstLetter())")
                                     .foregroundStyle(.green)
                                 Text("\(event.startTime.formatted(.dateTime))")
                                     .font(.caption)
                                 Spacer()
                                 HStack {
                                     Text("\(event.trustedContacts.count)")
                                     Image(systemName: "eye")
                                 }
                             }
                         }

                     }
                     
                 }
            }
        }
        .onAppear {
            //EventVM.getEventsOfCurrentUser()
            EventVM.getEventsOfTrustedContacts()
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
