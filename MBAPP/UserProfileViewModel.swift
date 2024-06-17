import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    private var db = Firestore.firestore()

    func fetchUserProfile(userID: String) {
        db.collection("users").document(userID).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            self.userProfile = try? document.data(as: UserProfile.self)
        }
    }

    func updateUserProfile(userID: String, userProfile: UserProfile) {
        do {
            try db.collection("users").document(userID).setData(from: userProfile)
        } catch {
            print("Error updating user profile: \(error)")
        }
    }
}
