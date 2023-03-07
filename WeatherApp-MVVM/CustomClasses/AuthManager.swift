//
//  AuthManager.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 07/03/23.
//

import Foundation
import FirebaseAuth

class AIAuthManager: NSObject {
    static let share = AIAuthManager()
    
    func isLoginUser()-> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func loginUser(email: String, password: String, completion: @escaping ((_ uid:String?, _ error: Error?)->Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(result?.user.uid, error)
        }
    }
    
    func registerNewUser(email: String, password: String, completion: @escaping ((_ uid:String?, _ error: Error?)->Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            completion(result?.user.uid, error)
        }
    }
    
    func logouUser(completion:((_ isSuccess:Bool)->Void)) {
        do {
           try Auth.auth().signOut()
            completion(true)
        }catch {
            completion(false)
        }
    }
}
