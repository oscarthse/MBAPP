import SwiftUI
import FirebaseFirestore

class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []

    private var db = Firestore.firestore()

    func fetchFriends() {
        db.collection("friends").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.friends = documents.compactMap { queryDocumentSnapshot -> Friend? in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let photoURL = data["photoURL"] as? String ?? ""
                return Friend(id: id, name: name, description: description, photoURL: photoURL)
            }
        }
    }

    func fetchUsersByPhoneNumbers(phoneNumbers: [String], completion: @escaping ([Friend]) -> Void) {
        // Implement logic to fetch users by phone numbers
        // This is a placeholder implementation
        db.collection("users").whereField("phoneNumber", in: phoneNumbers).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                completion([])
                return
            }
            let fetchedFriends = documents.compactMap { queryDocumentSnapshot -> Friend? in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let photoURL = data["photoURL"] as? String ?? ""
                return Friend(id: id, name: name, description: description, photoURL: photoURL)
            }
            completion(fetchedFriends)
        }
    }

    func addFriend(friend: Friend) {
        do {
            let _ = try db.collection("friends").addDocument(from: friend)
        } catch {
            print("Error adding friend: \(error)")
        }
    }
}
