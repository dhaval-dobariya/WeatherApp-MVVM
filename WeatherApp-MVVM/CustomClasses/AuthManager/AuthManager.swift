//
//  AuthManager.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import Foundation
import FirebaseAuth

class AIAuthManager: NSObject {
    static let share = AIAuthManager()
    
    /// Already user login ot not
    /// - Returns: true: Athu user already login, false: Athu user not login
    func isLoginUser()-> Bool {
        return Auth.auth().currentUser != nil
    }
    
    /// Get Auth user unique id
    /// - Returns: get string of user id
    func getuserId() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    /// Firebase auth user verification
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    ///   - completion: success verification completion
    func loginUser(email: String, password: String, completion: @escaping ((_ uid:String?, _ error: Error?)->Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(result?.user.uid, error)
        }
    }
    
    /// Register firebase new user
    /// - Parameters:
    ///   - email: user email
    ///   - password: user passoword
    ///   - completion: success register user completion
    func registerNewUser(email: String, password: String, completion: @escaping ((_ uid:String?, _ error: Error?)->Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            completion(result?.user.uid, error)
        }
    }
    
    /// Current Auth user logout
    /// - Parameter completion: success logout user completion
    func logouUser(completion:((_ isSuccess:Bool)->Void)) {
        do {
           try Auth.auth().signOut()
            completion(true)
        }catch {
            completion(false)
        }
    }
}
