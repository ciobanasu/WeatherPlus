//
//  APIURLS.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/29/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import Foundation

let CURRENT_LOCATION_URL = "https://api.weatherbit.io/v2.0/current?&lat=\(LocationServices.shared.latitude!)&lon=\(LocationServices.shared.longitude!)&key=b9b2845621c8482d8f3f3e918031e057"

let CURRENT_LOCATION_WEEKLY_FORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LocationServices.shared.latitude!)&lon=\(LocationServices.shared.longitude!)&days=7&key=b9b2845621c8482d8f3f3e918031e057"

let CURRENT_LOCATION_HOURLY_FORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LocationServices.shared.latitude!)&lon=\(LocationServices.shared.longitude!)&hours=24&key=b9b2845621c8482d8f3f3e918031e057"
