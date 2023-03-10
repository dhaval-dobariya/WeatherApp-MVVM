//
//  SignUpVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit

class SignUpVC: BaseVC {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var bioTextfield: UITextField!
    
    let viewModel = SignUpVM()
    var picker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    
    //MARK: - Methods
    
    /// To setup UIs for this screen
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImage_tapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(tapGesture)
        
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
                AlertBanner.failer(message: message)
            }
        }
        
        viewModel.successSignup = { [weak self] in
            self?.openHomeVC()
        }
        
    }

    
    //MARK: - IBAction
    
    @IBAction func LoginButton_Tapped(_ sender: UIButton) {
        self.goBack()
    }
    
    @IBAction func SignupButton_Tapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkValidation() {
            viewModel.newSingup(name: nameTextfield.text ?? "",
                                email: emailTextfield.text ?? "",
                                password: passwordTextfield.text ?? "",
                                bio: bioTextfield.text ?? "",
                                userImage: profileImageView.image)
        }
    }
    
    @objc func profileImage_tapped(_ sender: Any) {
        let alert = UIAlertController(title: "Select a photo", message: "Please Select an option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (_) in
            self.getImage(sourceType: .savedPhotosAlbum)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.getImage(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    /// A view controller present that take user selected image
    /// - Parameter sourceType: The type of picker interface to be displayed by the controller.
    func getImage(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
                print("camera souces not available")
                return
            }
        }
        checkMediaPermition(type: sourceType == .camera ? .camera: .photo) {
            DispatchQueue.main.async {
                self.picker = UIImagePickerController()
                self.picker.delegate = self
                self.picker.sourceType = sourceType
                self.picker.allowsEditing = true
                self.present(self.picker, animated: true, completion: nil)
            }
        }
    }
    
    
    /// Check user inputed data are not empty
    func checkValidation() -> Bool {
        var isValid: Bool = true
        
        if let tex = nameTextfield.text, tex.isEmpty {
            viewModel.changeHandler?(.error(message: Message.Validation.emptyName))
            isValid = false
            
        } else if let tex = emailTextfield.text, tex.isEmpty {
            viewModel.changeHandler?(.error(message: Message.Validation.InValidEmail))
            isValid = false
        
        } else if let tex = passwordTextfield.text, tex.isEmpty {
            viewModel.changeHandler?(.error(message: Message.Validation.emptyPassword))
            isValid = false
            
        } else if let tex = bioTextfield.text, tex.isEmpty {
            viewModel.changeHandler?(.error(message: Message.Validation.emptyBio))
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


/// ImagePicker Delegate Methods
extension SignUpVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = image
        }
    }

}
