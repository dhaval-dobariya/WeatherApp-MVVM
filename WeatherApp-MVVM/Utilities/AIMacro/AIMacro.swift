//
//  AIMacro.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 10/03/23.
//

import Foundation

//MARK:- VALIDATION MESSAGE

struct Message  {
    struct Validation {
        static let fillAllValue      = "Please fill all proper values."
        static let emptyPassword     = "Please enter valid password"
        static let emptyName         = "Please enter valid name"
        static let emptyEmail        = "Please enter valid email"
        static let InvalidPassword   = "Password length must be at least 6 characters"
        static let InValidEmail      = "Please enter valid email"
        static let emptyBio          = "Please enter a short biography"
        static let somethingWentWrong = "Something Went Wrong"
    }
    
    struct Alert {
        static let titlePermision           = "Permission"
        static let cameraAccessBody         = "This allow you to takes photos from within the app (e.g your profile photo)"
    }
    
    struct Info {
        static let userNotLogin           = "User not login"
    }
}
