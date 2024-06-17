import SwiftUI
import MapKit
import FirebaseFirestore

struct MainView: View {
    @StateObject var eventViewModel = EventViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.137154, longitude: 11.576124),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var showEventCreator = false
    @State private var showFriendsList = false
    @State private var showCalendar = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: eventViewModel.events) { event in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                            Text(event.description)
                                .font(.caption)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(height: 600)
                
                HStack {
                    CustomButton(text: "Friends") {
                        showFriendsList = true
                    }
                    .sheet(isPresented: $showFriendsList) {
                        FriendsView()
                    }
                    
                    CustomButton(text: "Launch") {
                        showEventCreator = true
                    }
                    .sheet(isPresented: $showEventCreator) {
                        EventCreatorView(eventViewModel: eventViewModel)
                    }
                    
                    CustomButton(text: "Calendar") {
                        showCalendar = true
                    }
                    .sheet(isPresented: $showCalendar) {
                        CalendarView(selectedDate: $selectedDate, events: $eventViewModel.events)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                eventViewModel.fetchEvents()
            }
        }
    }
}

struct CustomButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.white)
                .padding()
                .background(Color("customPurple"))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
        }
        .padding(.horizontal)
    }
}
