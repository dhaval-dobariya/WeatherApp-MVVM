//
//  SignUpVM.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit

class SignUpVM: BaseViewModel {
    
    var successSignup:(()->())?
    
    //MARK: - Api call
    
    /// Register new user in firesbse auth also firestore
    /// - Parameters:
    ///   - name: new user name
    ///   - email: new user email
    ///   - password: created new user password
    ///   - bio: speacified a user short biography
    ///   - userImage: user profile images
    func newSingup(name:String, email:String, password: String, bio:String, userImage: UIImage?) {
        self.changeHandler?(.loaderStart)
        AIAuthManager.share.registerNewUser(email: email, password: password) { uid, error in
            if let error = error {
                self.changeHandler?(.loaderEnd)
                self.changeHandler?(.error(message: error.localizedDescription) )
            }else {
                print("Success user id: ",uid ?? "not found")
                self.addUserFirestore(userId:uid ?? "", name: name, email: email, bio: bio, userImage: userImage)
            }
        }
        
    }
    
    /// upload curentuser profile image and store all details in firestore
    /// - Parameters:
    ///   - userId: user name
    ///   - name: user email
    ///   - email: user email
    ///   - bio: user bio
    ///   - userImage: user image
    fileprivate func addUserFirestore(userId: String, name:String, email:String, bio:String, userImage: UIImage?) {
        var param = ["uid": userId,
                     "name": name,
                     "email": email,
                     "bio": bio
        ]
        if let image = userImage {
            FirestoreManager.share.uploadImage(image) { profileUrl in
                print("user profile: ",profileUrl ?? "--")
                if let profileUrl = profileUrl?.absoluteString {
                    param["profile_image"] = profileUrl
                }
                self.changeHandler?(.loaderEnd)
                self.addUserFirestore(param: param)
            }
        }else {
            self.changeHandler?(.loaderEnd)
            self.addUserFirestore(param: param)
        }
    }
    
    /// User data store in firestore
    /// - Parameter param: param inside add key val of uid, name, email, bio, profile_image(string)
    fileprivate func addUserFirestore(param:[String:String]) {
        FirestoreManager.share.setUserData(param: param) { isSuccess in
            AIUser.shared = AIUser(dict: param)
            self.successSignup?()
        }
    }
}
