//
//  GlobalHelpers.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/25/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

var userDefaults = UserDefaults.standard

func currentDateFromUnix(unix: Double?) -> Date {
    if unix != nil {
        return Date(timeIntervalSince1970: unix!)
    } else {
        return Date()
    }
}

func getWeatherIcon(_ type: String) -> UIImage? {
    return UIImage(named: type)
}

func getFahrenheitFormatFrom(celsius: Double) -> Double {
     return (celsius * 9/5) + 32
}

func getTempBassedOnSettings(celsius: Double) -> Double {
    let format = getTempFormatFromUserdefaults()
    
    if format == TempFormat.celsius {
        return celsius
    } else {
        return getFahrenheitFormatFrom(celsius: celsius)
    }
}

func getTempFormatFromUserdefaults() -> String {
    if let tempFormat = userDefaults.value(forKey: "Temp") {
        if tempFormat as! Int == 0 {
            return TempFormat.celsius
        } else {
            return TempFormat.fahrenheit
        }
    } else {
        return TempFormat.celsius
    }
}
