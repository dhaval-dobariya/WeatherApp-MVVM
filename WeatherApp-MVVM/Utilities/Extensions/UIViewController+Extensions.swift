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
    
    func showAlert(title: String? = nil,
                   message: String = "Please wait...",
                   withLoadingIndicator isLoadingIndicator: Bool = false,
                   cancelActionTitle: String? = "OK!",
                   cancelAction:(() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isLoadingIndicator {
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.startAnimating();
            
            alertController.view.addSubview(loadingIndicator)
        }
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { action -> Void in
            if let cancelAction = cancelAction {
                cancelAction()
            }
        }
        alertController.addAction(cancelActionButton)
        
        present(alertController, animated:false, completion: nil)
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated:true)
    }
}
