import Foundation

struct Friend: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var photoURL: String // Add this field
}
