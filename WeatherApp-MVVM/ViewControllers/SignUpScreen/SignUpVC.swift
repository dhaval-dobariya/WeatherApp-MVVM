//
//  SignUpVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 07/03/23.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var bioTextfield: UITextField!
    
    let viewModel = SignUpVM()
    
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
        viewModel.successSignup = { [weak self] in
            self?.openHomeVC()
        }
        
        viewModel.failSignup = { [weak self] message in
            print("fail signup: ",message)
        }
    }

    
    //MARK: - Action
    
    @IBAction func LoginButton_Tapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SignupButton_Tapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkValidation() {
            viewModel.newSingup(name: nameTextfield.text ?? "",
                                email: emailTextfield.text ?? "",
                                password: passwordTextfield.text ?? "",
                                bio: bioTextfield.text ?? "",
                                profileUrl: "")
        }
    }
    
    
    // validation
    
    func checkValidation() -> Bool {
        var isValid: Bool = true
        
        if let tex = nameTextfield.text, tex.isEmpty {
            isValid = false
            
        } else if let tex = emailTextfield.text, tex.isEmpty {
            isValid = false
        
        } else if let tex = passwordTextfield.text, tex.isEmpty {
            isValid = false
            
        } else if let tex = bioTextfield.text, tex.isEmpty {
            isValid = false
        }
        
        return isValid
    }
    
    //MARK: - Redirection
    
    func openHomeVC() {
        let homeVc: HomeVC = HomeVC.instantiate(appStoryboard: .main)
        self.navigationController?.pushViewController(homeVc, animated: true)
    }
}
