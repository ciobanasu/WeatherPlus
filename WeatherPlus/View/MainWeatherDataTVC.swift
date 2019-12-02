//
//  MainWeatherDataTVC.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 12/1/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

class MainWeatherDataTVC: UITableViewCell {
    
    // MARK:  IBOutlets
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var templbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(weatherData: CityTempData) {
        cityLbl.text = weatherData.city
        cityLbl.adjustsFontSizeToFitWidth = true
        templbl.text = String(format: "%.0f%@", weatherData.temp, getTempFormatFromUserdefaults())
    }
}
