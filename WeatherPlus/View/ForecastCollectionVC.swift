//
//  ForecastCollectionVC.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/26/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

class ForecastCollectionVC: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(weather: HourlyForecast) {
        timeLbl.text = weather.date.getCurrentTime()
        weatherIcon.image = getWeatherIcon(weather.weatherIcon)
        
        tempLbl.text = String(format: "%.0f%@", weather.temp, getTempFormatFromUserdefaults())

    }
}
