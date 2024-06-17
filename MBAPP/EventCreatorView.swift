import SwiftUI
import MapKit
import FirebaseAuth
import FirebaseFirestore

struct EventCreatorView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var eventViewModel: EventViewModel
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var audience: String = "Friends"
    @State private var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.137154, longitude: 11.576124)
    @State private var description: String = ""
    @State private var coordinates: [IdentifiableCoordinate] = []

    var body: some View {
        VStack {
            Text("Create New Event")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            DatePicker("Select Date", selection: $date, displayedComponents: .date)
                .padding()
                .background(Color("customBackground"))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                .padding(.horizontal)

            DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                .padding()
                .background(Color("customBackground"))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                .padding(.horizontal)

            CustomTextField(placeholder: "Audience (Friends/Everyone)", text: $audience)
            CustomTextField(placeholder: "Description", text: $description)

            Map(coordinateRegion: Binding(
                get: { MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)) },
                set: { newValue in location = newValue.center }
            ),
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: coordinates) { coordinate in
                MapPin(coordinate: coordinate.coordinate, tint: .red)
            }
            .frame(height: 200)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            .padding(.horizontal)

            CustomButton(text: "Create Event") {
                let eventDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: time),
                                                      minute: Calendar.current.component(.minute, from: time),
                                                      second: 0, of: date) ?? date
                let newEvent = Event(creatorID: Auth.auth().currentUser?.uid ?? "",
                                     time: eventDate,
                                     audience: audience,
                                     location: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                                     description: description)
                eventViewModel.addEvent(event: newEvent)
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top)
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color("customBackground"))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            .padding(.horizontal)
    }
}
