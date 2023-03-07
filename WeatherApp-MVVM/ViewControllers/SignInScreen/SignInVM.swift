//
//  SignInVM.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 07/03/23.
//

import Foundation

class SignInVM: NSObject {

    var successSignin:(()->())?
    var failSignin:((_ message: String)->())?
    
    //MARK: - Api call
    
    func loginUser(email:String, password: String) {
        
        AIAuthManager.share.loginUser(email: email, password: password) { uid, error in
            if let error = error {
                self.failSignin?(error.localizedDescription )
            }else {
                print("Success user id: ",uid ?? "not found")
                self.successSignin?()
            }
        }
    }
}

