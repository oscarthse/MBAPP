import SwiftUI
import FirebaseStorage
import FirebaseAuth

struct UserProfileView: View {
    @StateObject var userProfileViewModel = UserProfileViewModel()
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var profileImage: UIImage? = UIImage(systemName: "person.circle")
    @State private var showImagePicker: Bool = false

    var userID: String

    var body: some View {
        VStack {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture {
                        showImagePicker = true
                    }
            }

            TextField("Name", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)

            TextField("Description", text: $description)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)

            Button(action: {
                uploadProfileImage()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
        }
        .onAppear {
            userProfileViewModel.fetchUserProfile(userID: userID)
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(image: $profileImage)
        })
        .padding()
    }

    func uploadProfileImage() {
        guard let image = profileImage else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(userID).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }

                if let url = url {
                    let userProfile = UserProfile(id: userID, name: name, description: description, photoURL: url.absoluteString)
                    userProfileViewModel.updateUserProfile(userID: userID, userProfile: userProfile)
                }
            }
        }
    }
}
