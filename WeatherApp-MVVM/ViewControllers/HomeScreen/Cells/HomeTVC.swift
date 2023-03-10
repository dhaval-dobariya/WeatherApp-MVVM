//
//  HomeTVC.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 10/03/23.
//

import UIKit

class HomeTVC: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wetherLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Set data of home tableview cell
    /// - Parameter model: current home screen single model
    func setupCell(model: HomeCellModel) {
        dateLabel.text      = model.date
        wetherLabel.text    = model.weather
    }
}
