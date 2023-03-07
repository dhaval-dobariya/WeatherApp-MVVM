//
//  SignInVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 07/03/23.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    let viewModel = SignInVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViewModel()
    }
    
    //MARK: - Methods
    
    func setup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupViewModel() {
        viewModel.successSignin = { [weak self] in
            self?.openHomeVC()
        }
        
        viewModel.failSignin = { [weak self] message in
            print("fail signin: ",message)
        }
    }
    
    
    //MARK: - Action
    
    @IBAction func LoginButton_Tapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkValidation() {
            viewModel.loginUser(email: emailTextfield.text ?? "",
                                password: passwordTextfield.text ?? "")
        }
    }
    
    @IBAction func SignupButton_Tapped(_ sender: UIButton) {
        self.openSignUpVC()
    }
    
    
    // validation
    
    func checkValidation() -> Bool {
        var isValid: Bool = true
        
        if let tex = emailTextfield.text, tex.isEmpty {
            isValid = false
        
        } else if let tex = passwordTextfield.text, tex.isEmpty {
            isValid = false
            
        }
        return isValid
    }

    //MARK: - Redirection
    
    func openSignUpVC() {
        let signUpVc: SignUpVC = SignUpVC.instantiate(appStoryboard: .main)
        self.navigationController?.pushViewController(signUpVc, animated: true)
    }
    
    func openHomeVC() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let sceneDelegate = windowScene?.delegate as? SceneDelegate {
            let homeVc: HomeVC = HomeVC.instantiate(appStoryboard: .main)
            let rootNC = UINavigationController(rootViewController: homeVc)
            sceneDelegate.window?.rootViewController = rootNC
        }
    }
}
