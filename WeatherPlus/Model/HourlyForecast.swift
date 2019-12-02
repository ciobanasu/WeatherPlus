//
//  HourlyForecast.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/25/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyForecast {
    
    private var _date: Date!
    private var _temp: Double!
    private var _weatherIcon: String!
    
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        
        let json = JSON(weatherDictionary)
        
        let curTemp = json[WeatherKeys.TEMP].double
        self._temp = getTempBassedOnSettings(celsius: curTemp ?? 0.0)
        
        let currentUnixDate = json[WeatherKeys.CURRENT_DATE].double!
        self._date = currentDateFromUnix(unix: currentUnixDate)
        
        self._weatherIcon = json[WeatherKeys.WEATHER][WeatherKeys.ICON].stringValue
    }
    
    class func downloadHourlyForecast(location: WeatherLocation, completion: @escaping (_ hourlyForecast: [HourlyForecast]) -> Void) {
        
        var HOURLY_FORECAST_URL: String!
        
        if !location.isCurrentLocation {
            let strinFormatUrl = "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@&country=%@&hours=24&key=b9b2845621c8482d8f3f3e918031e057"
            HOURLY_FORECAST_URL = String(format: strinFormatUrl, location.city, location.countryCode)
        } else {
            HOURLY_FORECAST_URL = CURRENT_LOCATION_HOURLY_FORECAST_URL
        }
        
        Alamofire.request(HOURLY_FORECAST_URL).responseJSON { (response) in
            
            let result = response.result
            var forecastArray: [HourlyForecast] = []
            
            if result.isSuccess {
                
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    // list = hourly forecast
                    if let list = dictionary[WeatherKeys.MAIN_DATA] as? [Dictionary<String, AnyObject>] {
                        
                        for item in list {
                            let forecast = HourlyForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                        
                    }
                }
                completion(forecastArray)
                
            } else {
                completion(forecastArray)
                print("no forecast details")
            }
            
        }
        
    }
    
}
