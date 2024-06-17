import SwiftUI
import FirebaseFirestore

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var db = Firestore.firestore()

    func fetchEvents() {
        db.collection("events").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.events = documents.compactMap { queryDocumentSnapshot -> Event? in
                return try? queryDocumentSnapshot.data(as: Event.self)
            }
        }
    }

    func addEvent(event: Event) {
        do {
            _ = try db.collection("events").addDocument(from: event)
        } catch {
            print(error)
        }
    }
}

