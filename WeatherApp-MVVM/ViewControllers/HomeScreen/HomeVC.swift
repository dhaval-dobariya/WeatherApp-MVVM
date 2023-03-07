//
//  HomeVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 07/03/23.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //MARK: - Methods
    
    func setup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: - Action
    
    @IBAction func LogoutButton_Tapped(_ sender: UIButton) {
        openLoginVC()
    }
    
    
    //MARK: - Redirection
    
    func openLoginVC() {
        AIAuthManager.share.logouUser { isSuccess in
            if isSuccess {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                if let sceneDelegate = windowScene?.delegate as? SceneDelegate {
                    let signVc: SignInVC = SignInVC.instantiate(appStoryboard: .main)
                    let rootNC = UINavigationController(rootViewController: signVc)
                    sceneDelegate.window!.rootViewController = rootNC
                    sceneDelegate.window!.makeKeyAndVisible()
                }
            }else {
                print("fail logout: ")
            }
        }
    }
}
