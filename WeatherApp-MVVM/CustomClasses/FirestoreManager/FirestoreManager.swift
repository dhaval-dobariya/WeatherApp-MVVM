//
//  FirestoreManager.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class FirestoreManager: NSObject {
    
    static let share = FirestoreManager()
    let db = Firestore.firestore()
    
    /// Store user details in firestore
    /// - Parameters:
    ///   - param: param inside add key val of uid, name, email, bio, profile_image(string)
    ///   - completion: success data store completion
    func setUserData(param:[String: Any], completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let uid = param["uid"] as? String else {
            print("uid not found")
            completion(false)
            return
        }
        db.collection("Users").document(uid).setData(param) { err in
            if err != nil{
                print("insert time error",err?.localizedDescription ?? "")
                
            } else {
                print("user insert successFully..")
            }
            completion(err == nil)
        }
    }
    
    /// Get user details from firestore
    /// - Parameters:
    ///   - loginId: uniques user id for fetching that user details
    ///   - completion: success user data completion
    func getUserData(loginId:String,completion: @escaping (_ data: [String:Any],_ error: Error?) -> Void) {
        db.collection("Users").document(loginId).getDocument { snapshot, error in
            if let error = error {
                completion([:], error)
            } else if let data = snapshot?.data() {
                completion(data, nil)
            }else {
                completion([:], nil)
            }
        }
    }
    
    /// get image url from firebase storage 
    /// - Parameters:
    ///   - image: uploading image data
    ///   - completion: success uploade image completion
    func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) { //at reference: StorageReference,
        
        let date = Date().timeIntervalSince1970
        
        let reference = Storage.storage().reference().child("Profileimages").child("userimage_\(date)")
        
        // 1
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return completion(nil)
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        // 2d
        reference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }

            // 4
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
}
