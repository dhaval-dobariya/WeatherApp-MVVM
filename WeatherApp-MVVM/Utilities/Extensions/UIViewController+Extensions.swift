//
//  UIViewController+Extensions.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit

enum AppStoryboard: String {
    case main = "Main"
}

extension UIViewController {
    class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T {

        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    /// Pop curret viewController from naviation stack
    func goBack() {
        self.navigationController?.popViewController(animated:true)
    }
}
