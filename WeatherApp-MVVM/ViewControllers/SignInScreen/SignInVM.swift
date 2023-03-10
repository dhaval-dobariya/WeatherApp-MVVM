//
//  SignInVM.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import Foundation

class SignInVM: BaseViewModel {

    var successSignin:(()->())?
    
    //MARK: - Api call
    
    /// User credetional throught auth login in firebase
    /// - Parameters:
    ///   - email: User unique emial
    ///   - password: User password with associath email
    func loginUser(email:String, password: String) {
        self.changeHandler?(.loaderStart)
        AIAuthManager.share.loginUser(email: email, password: password) { uid, error in
            self.changeHandler?(.loaderEnd)
            if let error = error {
                self.changeHandler?( .error(message: error.localizedDescription) )
            }else {
                print("Success user id: ",uid ?? "not found")
                self.getUserInfo(uid: uid)
            }
        }
    }
    
    /// Get user information from firebase
    /// - Parameter uid: Unique indetify of user
    fileprivate func getUserInfo(uid:String?) {
        FirestoreManager.share.getUserData(loginId: uid ?? "") { (data, error) in
            AIUser.shared = AIUser(dict: data)
            self.successSignin?()
        }
    }
}

