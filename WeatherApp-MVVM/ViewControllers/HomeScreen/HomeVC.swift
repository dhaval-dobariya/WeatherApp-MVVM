//
//  HomeVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import UIKit
import SDWebImage

class HomeVC: BaseVC {

    @IBOutlet weak var profilecontaintView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cityContaintView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    let viewModel = HomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
    }
    
    //MARK: - Methods
    
    /// To setup UIs for this screen
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        for widget in [profilecontaintView, cityContaintView] {
            widget?.layer.borderColor = UIColor.lightGray.cgColor
            widget?.layer.borderWidth = 1
            widget?.layer.cornerRadius = 10
        }
        listTableView.registerCell(HomeTVC.self)
    }

    
    /// to setup view-model for completon APIs
    private func setupViewModel() {
        viewModel.successGetUserDetails = { [weak self] in
            self?.fillUserInfo()
            self?.viewModel.fetchWeather()
        }
        
        viewModel.updateDataModel = { [weak self] in
            self?.listTableView.reloadData()
        }
        
        viewModel.changeHandler = { [unowned self] change in
            switch change {
            case .loaderStart:
                self.showActivityIndicator()
                break
                
            case .loaderEnd:
                self.hideActivityIndicator()
                break
                
            case .error(let message):
                AlertBanner.notification(message: message)
                break
            }
        }
        
        if AIUser.shared.uid.isEmpty {
            viewModel.getuserData()
        }else {
            fillUserInfo()
            viewModel.fetchWeather()
        }
    }
    
    
    /// Show currrent user profile details
    func fillUserInfo() {
        let model = AIUser.shared
        nameLabel.text  = model.name
        bioLabel.text   = model.bio
        profileImage.sd_setImage(with: URL(string: model.image ?? ""), placeholderImage: UIImage(named: "ic_user_gray"))
    }
    
    
    //MARK: - IBAction
    
    @IBAction func LogoutButton_Tapped(_ sender: UIButton) {
        openLoginVC()
    }
    
    @IBAction func SearchButton_Tapped(_ sender: UIButton) {
        self.searchTextField.endEditing(true)
        if let searchTxt = self.searchTextField.text, !searchTxt.isEmpty {
            viewModel.fetchWeather(city: searchTxt.lowercased())
        }else {
            viewModel.changeHandler?(.error(message: "Please enter propar city."))
        }
        
    }
    
    
    //MARK: - Redirection
    
    /// Show weather screen
    /// - Parameters:
    ///   - model: model as forcast list single object
    ///   - city: which city data in model to passed
    func openWeatherDetailsVC(model: List, city: String?) {
        let weatherVC: WeatherDetailsVC = WeatherDetailsVC.instantiate(appStoryboard: .main)
        weatherVC.selectedWeather = model
        weatherVC.city = city
        self.navigationController?.pushViewController(weatherVC, animated: true)
    }
    
    /// App set login screen as a root
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


/// TableView deleget and Datasource
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataLabel.isHidden = viewModel.numberOfCell != 0
        return viewModel.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.setupCell(model: cellVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel.getSelectedModel(at: indexPath) {
            openWeatherDetailsVC(model: model, city: viewModel.forecastModels?.city?.name)
        }else {
            viewModel.changeHandler?(.error(message: "No found more details"))
        }
    }
}
