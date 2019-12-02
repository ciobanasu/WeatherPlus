//
//  WeatherView.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/25/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    // MARK: IBOutlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var weatherInfoLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomViewContainer: UIView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Vars
    var currentWeather: CurrentWeather!
    var weeklyWeatherForecast: [WeeklyWeatherForecast] = []
    var dailyWeatherForecast: [HourlyForecast] = []
    var weatherInfoData: [WeatherInfoForecast] = []
    
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainInit()
    }
    
    // MARK: Funcs
    private func mainInit() {
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
    }
    
    private func setupTableView() {
        let cellIdentifier = "Cell"
        let bundle = Bundle.main
        let nibName = "WeatherTableViewCell"
        let nib = UINib(nibName: nibName, bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupHourlyCollectionView() {
        hourlyWeatherCollectionView.registerCollectionViewCell(nibName: "ForecastCollectionVC")
        hourlyWeatherCollectionView.dataSource = self
    }
    
    private func setupInfoCollectionView() {
        infoCollectionView.registerCollectionViewCell(nibName: "InfoCollectionVC")
        infoCollectionView.dataSource = self
    }
    
    func refreshData() {
        setupCurrentWeather()
        setupWeatherInfo()
        infoCollectionView.reloadData()
    }
    
    private func setupCurrentWeather() {
        cityNameLbl.text = currentWeather.city
        dateLbl.text = "Today, \(currentWeather.date.getShortDate())"
        tempLbl.text = String(format: "%.0f%@", currentWeather.currentTemp, getTempFormatFromUserdefaults())

        weatherInfoLbl.text = currentWeather.weatherType
    }
    
    private func setupWeatherInfo() {
        let winSpeed = String(format: "%.1f m/sec", currentWeather.windSpeed)
        let windInfo = WeatherInfoForecast(infoTxt: winSpeed, nameTxt: nil, imgInfo: getWeatherIcon("wind"))
        
        let humidity = String(format: "%.0f", currentWeather.humidity)
        let humidityInfo = WeatherInfoForecast(infoTxt: humidity, nameTxt: nil, imgInfo: getWeatherIcon("humidity"))
        
        let pressure = String(format: "%.0f mb", currentWeather.pressure)
        let pressureInfo = WeatherInfoForecast(infoTxt: pressure, nameTxt: nil, imgInfo: getWeatherIcon("pressure"))
        
        let visibility = String(format: "%.0f km", currentWeather.visibility)
        let visibilityInfo = WeatherInfoForecast(infoTxt: visibility, nameTxt: nil, imgInfo: getWeatherIcon("visibility"))
        
        let feelsLike = String(format: "%.1f", currentWeather.feelsLike)
        let feelsLikeInfo = WeatherInfoForecast(infoTxt: feelsLike, nameTxt: nil, imgInfo: getWeatherIcon("feelsLike"))
        
        let uv = String(format: "%.1f", currentWeather.uv)
        let uvInfo = WeatherInfoForecast(infoTxt: uv, nameTxt: "UV Index", imgInfo: nil)
        
        let sunriseInfo = WeatherInfoForecast(infoTxt: currentWeather.sunrise, nameTxt: nil, imgInfo: getWeatherIcon("sunrise"))
        
        let sunsetInfo = WeatherInfoForecast(infoTxt: currentWeather.sunset, nameTxt: nil, imgInfo: getWeatherIcon("sunset"))
        
        weatherInfoData = [windInfo, humidityInfo, pressureInfo, visibilityInfo, feelsLikeInfo, uvInfo, sunriseInfo, sunsetInfo]
    }
    
}

// MARK: Extension for tableView delegate and data source

extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weeklyWeatherForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.generateWeekDayCellInfo(weeklyForecast: weeklyWeatherForecast[indexPath.row])
        return cell
    }
      
}

// MARK: Extension for cillection view data source

extension WeatherView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == hourlyWeatherCollectionView {
            return dailyWeatherForecast.count
        } else {
            return weatherInfoData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyWeatherCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCollectionVC
            cell.generateCell(weather: dailyWeatherForecast[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InfoCollectionVC
            cell.generateCellForecastInfo(weatherInfo: weatherInfoData [indexPath.row])
            return cell
        }
    }
 
}
