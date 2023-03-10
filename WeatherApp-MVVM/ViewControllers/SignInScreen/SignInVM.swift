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
    
    fileprivate func getUserInfo(uid:String?) {
        FirestoreManager.share.getUserData(loginId: uid ?? "") { (data, error) in
            AIUser.shared = AIUser(dict: data)
            self.successSignin?()
        }
    }
}

