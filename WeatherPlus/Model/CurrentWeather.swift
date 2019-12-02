//
//  CurrentWeather.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/25/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!
    private var _feelsLike: Double!
    private var _uv: Double!
    
    private var _weatherType: String!
    private var _pressure: Double! //mb
    private var _humidity: Double! //%
    private var _windSpeed: Double! // meter / sec
    private var _weatherIcon: String!
    private var _visibility: Double! // km
    private var _sunrise: String!
    private var _sunset: String!
    
    var city: String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var feelsLike: Double {
           if _feelsLike == nil {
               _feelsLike = 0.0
           }
           return _feelsLike
       }
    
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    
    var humidity: Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    var visibility: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }

    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
   // MARK: Get weather 
    func getCurrentWeather(location: WeatherLocation, completion: @escaping(_ succes: Bool) -> Void) {
        
        var LOCATIONAPI_URL: String!
        
        //"https://api.weatherbit.io/v2.0/current?city=Chisinau&country=MD&key=d1473eadd57b41388846ac15298b3832&lang=ro"
        
        if !location.isCurrentLocation {
            let strinFormatUrl = "https://api.weatherbit.io/v2.0/current?city=%@&country=%@&key=b9b2845621c8482d8f3f3e918031e057"
            LOCATIONAPI_URL = String(format: strinFormatUrl, location.city, location.countryCode)
        } else {
            LOCATIONAPI_URL = CURRENT_LOCATION_URL
        }
        
        Alamofire.request(LOCATIONAPI_URL).responseJSON { (response) in
            
            let result = response.result
            
            if result.isSuccess {
                
                let json = JSON(result.value!)
                
                self._city = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.CITY_NAME].stringValue
                
                let currentDate = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.CURRENT_DATE]
                
                self._date = currentDateFromUnix(unix: currentDate.double)
                
                self._weatherType = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.WEATHER][WeatherKeys.DESCRIPTION].stringValue
                
                let curTemp = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.TEMP].double
                self._currentTemp = getTempBassedOnSettings(celsius: curTemp ?? 0.0)
                
                let fellsLike = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.APP_TEMP].double
                self._feelsLike = getTempBassedOnSettings(celsius: fellsLike ?? 0.0)
                
                self._pressure = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.PRESSURE].double
                self._humidity = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.HUMIDITY].double
                self._windSpeed = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.WIND_SPEED].double
                self._weatherIcon = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.WEATHER][WeatherKeys.ICON].stringValue
                self._visibility = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.VISIBILITY].double
                self._uv = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.UV].double
                self._sunrise = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.SUNRISE].stringValue
                self._sunset = json[WeatherKeys.MAIN_DATA][0][WeatherKeys.SUNSET].stringValue 
                
                completion(true)
                
            } else {
                self._city = location.city
                completion(false)
                print("No result found for current location")
            }
        }
    }
}
