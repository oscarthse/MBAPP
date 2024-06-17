import SwiftUI

struct FriendsView: View {
    @StateObject var friendsViewModel = FriendsViewModel()

    var body: some View {
        VStack {
            Text("Bump your iPhones to add friends when in this page.")
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)

            List(friendsViewModel.friends) { friend in
                VStack(alignment: .leading) {
                    Text(friend.name)
                        .font(.headline)
                    Text(friend.description)
                        .font(.subheadline)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            }

            Button("Show Profile") {
                // Show Profile action
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical)

            Button("Bump to Add Friend") {
                // Bump to Add Friend action
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical)

            Button("Add Friends from Contacts") {
                // Add Friends from Contacts action
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical)
        }
        .onAppear {
            friendsViewModel.fetchFriends()
        }
        .padding()
    }
}
