//
//  HomeVM.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import Foundation

class HomeVM: BaseViewModel {
    
    var forecastModels: Forecast?
    var successGetUserDetails:(()->())?
    var updateDataModel:(()->())?
    
    private var cellViewModel: [HomeCellModel] = [HomeCellModel]() {
        didSet {
            self.updateDataModel?()
        }
    }
    
    /// Get total number of cell object
    var numberOfCell:Int {
        return cellViewModel.count
    }
    
    /// Fetch user details for Already login user
    func getuserData() {
        let loginId = AIAuthManager.share.getuserId()
        FirestoreManager.share.getUserData(loginId: loginId) { data, error in
            if let error = error {
                print("Fail Fetch Current user data ", error.localizedDescription)
            }else {
                AIUser.shared = AIUser(dict: data)
                self.successGetUserDetails?()
            }
        }
    }
    
    /// Get Call 5 day / 3 hour forecast data
    func fetchWeather(city:String = "Kolkata") {
        let param = [
            "q": city,
            "appid": CredentialKey.OpenWeatherMap,
            "units": "metric"
        ] as [String: Any]
        
        self.cellViewModel = []
        self.changeHandler?(.loaderStart)
        ServiceManager.callGETApiWithNetCheck(url: getUrl(URL_FORCAST), headersRequired: false, params: param) { response, isSuccess in
            self.changeHandler?(.loaderEnd)
            
                switch response!.result {
                case .success(let JSON):
                    if let dictJson = JSON as? NSDictionary, isSuccess {
                        self.processForecast(dictJson)
                    }else {
                        let message = (JSON as? NSDictionary)?.value(forKey: "message") as? String ?? Message.Validation.somethingWentWrong
                        self.changeHandler?(.error(message: message))
                    }
                    
                case .failure(let error):
                    print("Fail api : ",error.localizedDescription)
                    self.changeHandler?(.error(message: error.localizedDescription))
                }
                
        }
    }
    
    /// Forecate dict convert home screen cell model
    /// - Parameter dict: Forecate details ad Nsdictionary
    func processForecast(_ dict: NSDictionary) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            self.forecastModels = try JSONDecoder().decode(Forecast.self, from: data)
            if let cellModel = self.forecastModels?.list?.compactMap({ createCellModel(model: $0)}), !cellModel.isEmpty {
                self.cellViewModel = cellModel
            }else {
                self.cellViewModel = []
                self.changeHandler?(.error(message: "No weather data found"))
            }
            
        } catch {
            print("error in weather list json \(error)")
            self.changeHandler?(.error(message: error.localizedDescription))
        }
    }
    
    //MARK: - Cell Function
    
    /// Convert forecate mode data to homecellModel
    /// - Parameter model: forecast of list model
    /// - Returns: A HomecellModel object with the associated indextPath.
    private func createCellModel(model: List) -> HomeCellModel {
        return HomeCellModel(date: model.dtTxt ?? "",
                             weather: model.weather?.first?.main?.rawValue ?? "",
                             clouds: String(model.clouds?.all ?? 0 ) ,
                             wind: String(model.wind?.speed ?? 0)
        )
    }
    
    /// Get cell Viewmodel for associated tableview cell
    /// - Parameter indexPath:  The index path specifying the location of the cellViewModel
    /// - Returns: A HomecellModel object with the associated indextPath.
    func getCellViewModel(at indexPath:IndexPath) -> HomeCellModel {
        return self.cellViewModel[indexPath.row]
    }
    
    /// Get forecast model
    /// - Parameter indexPath: The index path specifying the location of the forecast list
    /// - Returns: A Forecast List object with the associated indextPath.
    func getSelectedModel(at indexPath:IndexPath) -> List? {
        if let list = self.forecastModels?.list {
            return list[indexPath.row]
        }
        return nil
    }
}


struct HomeCellModel {
    var date       : String
    var weather    : String
    var clouds     : String
    var wind       : String
}
