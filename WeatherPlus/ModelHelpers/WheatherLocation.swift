//
//  WheatherLocation.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/29/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

struct WeatherLocation: Codable, Equatable {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
}
