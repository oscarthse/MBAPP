import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var creatorID: String
    var time: Date
    var audience: String
    var location: GeoPoint
    var description: String
}
