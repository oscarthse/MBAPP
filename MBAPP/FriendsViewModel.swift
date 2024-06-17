import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []

    private var db = Firestore.firestore()

    func fetchFriends() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        db.collection("friends").whereField("userID", isEqualTo: userID).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.friends = documents.compactMap { queryDocumentSnapshot -> Friend? in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let photoURL = data["photoURL"] as? String
                return Friend(id: id, name: name, description: description, photoURL: photoURL)
            }
        }
    }

    func fetchUsersByPhoneNumbers(phoneNumbers: [String], completion: @escaping ([Friend]) -> Void) {
        db.collection("users").whereField("phoneNumber", in: phoneNumbers).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            let friends = documents.compactMap { queryDocumentSnapshot -> Friend? in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let photoURL = data["photoURL"] as? String
                return Friend(id: id, name: name, description: description, photoURL: photoURL)
            }

            completion(friends)
        }
    }
}

struct Friend: Identifiable {
    var id: String
    var name: String
    var description: String
    var photoURL: String?
}
