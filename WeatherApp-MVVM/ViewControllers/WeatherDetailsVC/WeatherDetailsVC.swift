//
//  WeatherDetailsVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 10/03/23.
//

import UIKit

class WeatherDetailsVC: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!

    var city:String?
    var selectedWeather: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    /// To setup UIs for this screen
    func setupUI() {
        if let model = selectedWeather {
            cityNameLabel.text      = city ?? "-"
            temperatureLabel.text   = String(model.main?.temp ?? 0) + " Celsius"
            weatherLabel.text       = model.weather?.first?.description ?? "-"
            windLabel.text          = String(model.wind?.speed ?? 0)
            humidityLabel.text      = String(model.main?.humidity ?? 0)
            if let icon = model.weather?.first?.icon {
                let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(icon).png")
                weatherIconImage.sd_setImage(with: iconUrl)
            }
        }
        
    }
    
    //MARK: - IBAction
    
    @IBAction func BackButton_Tapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
