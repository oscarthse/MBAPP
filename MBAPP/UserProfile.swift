import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var photoURL: String
}
