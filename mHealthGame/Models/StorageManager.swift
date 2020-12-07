//
//  StorageManager.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 20/11/2563 BE.
//

import FirebaseStorage

public class StorageManager {
    static let shared = StorageManager()
    // MARK: - PUBLIC
    private let storage = Storage.storage().reference(forURL: "gs://mhealth-821d6.appspot.com")
    
    public func storeImage(uid: String , image: UIImage){
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        let storageRef = storage.child("profile").child(uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metadata) { ( StorageMetadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let imageURL = url?.absoluteString{
                    DatabaseManager.shared.updateDownloadURL(url: imageURL, uid: uid)
                }
                else {
                    print("failed to register image url to database ")
                }
            }
        }
    }
}
