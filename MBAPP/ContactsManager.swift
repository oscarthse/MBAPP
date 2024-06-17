import Contacts

class ContactsManager {
    let store = CNContactStore()
    var friendsViewModel = FriendsViewModel()

    func requestAccess(completion: @escaping (Bool) -> Void) {
        store.requestAccess(for: .contacts) { granted, error in
            completion(granted)
        }
    }

    func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
        var contacts: [CNContact] = []
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

        do {
            try store.enumerateContacts(with: request) { contact, stop in
                contacts.append(contact)
            }
            completion(contacts)
        } catch {
            print("Failed to fetch contact, error: \(error)")
            completion([])
        }
    }

    func findAppUsers(contacts: [CNContact], completion: @escaping ([Friend]) -> Void) {
        let phoneNumbers = contacts.flatMap { $0.phoneNumbers.map { $0.value.stringValue } }
        friendsViewModel.fetchUsersByPhoneNumbers(phoneNumbers: phoneNumbers, completion: completion)
    }
}
