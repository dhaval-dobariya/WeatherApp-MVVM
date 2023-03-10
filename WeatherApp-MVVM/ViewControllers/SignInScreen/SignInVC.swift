//
//  SignInVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit

class SignInVC: BaseVC {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    let viewModel = SignInVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    //MARK: - Methods
    
    /// To setup UIs for this screen
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /// to setup view-model for completon APIs
    private func setupViewModel() {
        viewModel.changeHandler = { [weak self] change in
            switch change {
            case .loaderStart:
                self?.showActivityIndicator()
                
            case .loaderEnd:
                self?.hideActivityIndicator()
                
            case .error(message: let message):
                AlertBanner.notification(message: message)
            }
        }
        
        viewModel.successSignin = { [weak self] in
            self?.openHomeVC()
        }
        
    }
    
    
    //MARK: - IBAction
    
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
    
    
    /// Check user inputed data are not empty
    func checkValidation() -> Bool {
        var isValid: Bool = true
        
        if let tex = emailTextfield.text, tex.isEmpty {
            viewModel.changeHandler?(.error(message: Message.Validation.InValidEmail))
            isValid = false
        
        } else if let tex = passwordTextfield.text, tex.isEmpty {
            viewModel.changeHandler?(.error(message: Message.Validation.emptyPassword))
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
