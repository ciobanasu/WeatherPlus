//
//  WeatherTableViewCell.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/26/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var weekDayLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherIconImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateWeekDayCellInfo(weeklyForecast: WeeklyWeatherForecast) {
        weekDayLbl.text = weeklyForecast.date.getDayOfWeek()
        weatherIconImg.image = getWeatherIcon(weeklyForecast.weatherIcon)
        
        tempLbl.text = String(format: "%.0f%@", weeklyForecast.temp, getTempFormatFromUserdefaults())
    }
}
