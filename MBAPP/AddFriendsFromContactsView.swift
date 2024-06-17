import SwiftUI
import Contacts

struct AddFriendsFromContactsView: View {
    @StateObject var contactsManager = ContactsManager()
    @ObservedObject var friendsViewModel: FriendsViewModel

    var body: some View {
        VStack {
            List(contactsManager.contacts, id: \.self) { contact in
                HStack {
                    Text(contact.givenName + " " + contact.familyName)
                    Spacer()
                    Button(action: {
                        // Add friend logic
                        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                            friendsViewModel.fetchUsersByPhoneNumbers(phoneNumbers: [phoneNumber]) { fetchedFriends in
                                if let firstFriend = fetchedFriends.first {
                                    friendsViewModel.addFriend(friend: firstFriend)
                                }
                            }
                        }
                    }) {
                        Text("Add Friend")
                    }
                    .buttonStyle(CustomButtonStyle())
                }
            }
            .onAppear {
                contactsManager.requestAccess()
            }
        }
    }
}
