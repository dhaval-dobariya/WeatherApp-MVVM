//
//  AIUser.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import Foundation

class AIUser: NSObject {
    static var shared = AIUser()
    var uid:String = ""
    var name: String = ""
    var email: String?
    var image: String?
    var bio: String?
    
    override init() {
        super.init()
    }
    
    init(dict:[String:Any]) {
        uid     = dict["uid"] as? String ?? ""
        name    = dict["name"] as? String ?? ""
        email   = dict["email"] as? String ?? ""
        image   = dict["profile_image"] as? String ?? ""
        bio     = dict["bio"] as? String ?? ""
    }
}
