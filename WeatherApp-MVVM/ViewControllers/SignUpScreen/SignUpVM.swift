//
//  SignUpVM.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 07/03/23.
//

import Foundation

class SignUpVM: NSObject {
    
    var successSignup:(()->())?
    var failSignup:((_ message: String)->())?
    
    //MARK: - Api call
    
    func newSingup(name:String, email:String, password: String, bio:String, profileUrl: String) {
        
        AIAuthManager.share.registerNewUser(email: email, password: password) { uid, error in
            if let error = error {
                self.failSignup?(error.localizedDescription )
            }else {
                print("Success user id: ",uid ?? "not found")
                self.successSignup?()
            }
        }
    }
}
