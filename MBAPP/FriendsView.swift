import SwiftUI
import FirebaseAuth

struct FriendsView: View {
    @StateObject var friendsViewModel = FriendsViewModel()
    @State private var showProfileView = false
    @State private var bumpManager = BumpManager()

    var body: some View {
        VStack {
            Text("Bump your iPhones to add friends when in this page.")
                .font(.headline)
                .padding()

            List(friendsViewModel.friends) { friend in
                HStack {
                    if let photoURL = friend.photoURL, let url = URL(string: photoURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.circle")
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        Text(friend.name)
                        Text(friend.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            }
            .onAppear {
                friendsViewModel.fetchFriends()
            }
            .padding()

            Button("Show Profile") {
                showProfileView = true
            }
            .padding()
            .sheet(isPresented: $showProfileView) {
                UserProfileView(userID: Auth.auth().currentUser?.uid ?? "")
            }

            Button("Bump to Add Friend") {
                bumpManager.beginSession()
            }
            .padding()
        }
    }
}
