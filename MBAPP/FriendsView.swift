import SwiftUI
import FirebaseFirestore

struct Friend: Identifiable {
    var id: String
    var name: String
}

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
                return Friend(id: id, name: name)
            }
        }
    }
}

//Test git

struct FriendsView: View {
    @StateObject var friendsViewModel = FriendsViewModel()

    var body: some View {
        VStack {
            List(friendsViewModel.friends) { friend in
                Text(friend.name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
            }
        }
        .onAppear {
            friendsViewModel.fetchFriends()
        }
        .padding()
    }
}
