import SwiftUI
import Contacts

class ContactsManager: ObservableObject {
    @Published var contacts = [CNContact]()

    func requestAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.fetchContacts()
            } else {
                print("Access denied")
            }
        }
    }

    private func fetchContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            var contacts = [CNContact]()
            try store.enumerateContacts(with: request) { contact, stop in
                contacts.append(contact)
            }
            DispatchQueue.main.async {
                self.contacts = contacts
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
}
