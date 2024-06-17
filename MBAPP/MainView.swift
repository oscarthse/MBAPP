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
        ZStack {
            GradientBackground()
            VStack {
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: eventViewModel.events) { event in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20) // Reduce the size
                                .foregroundColor(.red)
                            Text(event.description)
                                .font(.caption2) // Use a smaller font
                                .padding(3) // Reduce padding
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(5) // Reduce corner radius
                                .shadow(radius: 2) // Reduce shadow
                        }
                        .frame(width: 80) // Set a fixed width to keep it consistent
                    }
                }
                .frame(height: 600)
                
                HStack {
                    Button("Friends") {
                        showFriendsList = true
                    }
                    .buttonStyle(CustomButtonStyle())
                    .sheet(isPresented: $showFriendsList) {
                        FriendsView()
                    }
                    
                    Button("Launch") {
                        showEventCreator = true
                    }
                    .buttonStyle(CustomButtonStyle())
                    .sheet(isPresented: $showEventCreator) {
                        EventCreatorView(eventViewModel: eventViewModel)
                    }
                    
                    Button("Calendar") {
                        showCalendar = true
                    }
                    .buttonStyle(CustomButtonStyle())
                    .sheet(isPresented: $showCalendar) {
                        CalendarView(selectedDate: $selectedDate, events: $eventViewModel.events)
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            eventViewModel.fetchEvents()
        }
    }
}
