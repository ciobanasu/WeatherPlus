//
//  WeatherVC.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/25/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    var userDefaults = UserDefaults.standard
    
    var allLocations: [WeatherLocation] = []
    var allWeatherViews: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    
    var shouldRefresh = true
    
    
    // MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        scrollView.delegate = self

        // stop scrolling on the first and last page
        scrollView.bounces = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldRefresh {
            allLocations = []
            allWeatherViews = []
            removeViewsFromSubView()
            
            locationAuthCheck()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // we do not need to update more, the location
        locationManagerStop()
    }
    
    
    //MARK: Get Weather
    
    private func getWeather() {
        loadLocationsFromUserDefaults()
        createWeatherView()
        addWeatherToScrollView()
        setupPageControllerPageNum()
    }
    
    // MARK:  Remove Views
    private func removeViewsFromSubView() {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func createWeatherView() {
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
    }
    
    private func addWeatherToScrollView() {
        for i in 0..<allWeatherViews.count {
            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            getCurrentWeather(weatherView: weatherView, location: location)
            getWeeklyWeather(weatherView: weatherView, location: location)
            getHourlyWeather(weatherView: weatherView, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(weatherView)
            scrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
        }
    }
    
    private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: location) { (succes) in
            
            weatherView.refreshData()
            
            self.generateWeatherList()
        }
    }
    
    private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation) {
        WeeklyWeatherForecast.downloadWeeklyWeatherForecast(location: location) { (weatherForecasts) in
            weatherView.weeklyWeatherForecast = weatherForecasts
            weatherView.tableView.reloadData()
        }
    }
    
    private func getHourlyWeather(weatherView: WeatherView, location: WeatherLocation) {
        HourlyForecast.downloadHourlyForecast(location: location) { (weatherForecasts) in
             weatherView.dailyWeatherForecast = weatherForecasts
             weatherView.hourlyWeatherCollectionView.reloadData()
        }
    }
    
    // MARK:  Load locations from user defaults
    private func loadLocationsFromUserDefaults() {
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)

        let HongKong = WeatherLocation(city: "Hong_Kong", country: "Hong King", countryCode: "HK", isCurrentLocation: false)
        
        let Tokyo = WeatherLocation(city: "Tokyo", country: "Japan", countryCode: "JP", isCurrentLocation: false)
        
        let Moscow = WeatherLocation(city: "Moscow", country: "Russia", countryCode: "RU", isCurrentLocation: false)
        
        let Kiev = WeatherLocation(city: "Kiev", country: "Ukraine", countryCode: "UA", isCurrentLocation: false)

        if let data = userDefaults.value(forKey: "Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            allLocations.insert(currentLocation, at: 0)
            allLocations.insert(HongKong, at: 1)
            allLocations.insert(Tokyo, at: 2)
            allLocations.insert(Moscow, at: 3)
            allLocations.insert(Kiev, at: 4)
        } else {
            print("No data")
            allLocations.append(currentLocation)
        }
    }
    
    // MARK:  Page controll
    
    private func setupPageControllerPageNum() {
        pageControll.numberOfPages = allWeatherViews.count
    }
    
    private func updatePageControllerSelectedPage(currentPage: Int) {
        pageControll.currentPage = currentPage
    }
    
    // MARK:  Location manager
    private func locationManagerStart() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop() {
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate

            if currentLocation != nil {
                // set coordinates
                LocationServices.shared.latitude = currentLocation.latitude
                LocationServices.shared.longitude = currentLocation.longitude
                getWeather()
            } else {
                locationAuthCheck()
            }
        } else {
            print("Location was crahed")
            // request autorizations to get current location
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
    
    private func generateWeatherList() {
        allWeatherData = []
        
        for weatherView in allWeatherViews {
            let tempData = CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTemp)
            allWeatherData.append(tempData)
        }
    }
    
    // MARK:  Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLocations" {
            let destinationVC = segue.destination as! AllLocationsTableVC
            destinationVC.weatherData = allWeatherData
            destinationVC.delegate = self
        }
    }
    
}

extension WeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location, \(error.localizedDescription)")
    }
}

extension WeatherVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatePageControllerSelectedPage(currentPage: Int(round(value)))
    }
}

extension WeatherVC: AllLocationsTableVCDelegate {
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool) {
        let viewIndex = CGFloat(integerLiteral: atIndex)
        let newOffset = CGPoint(x: (scrollView.frame.width + 1.0) * viewIndex, y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
        updatePageControllerSelectedPage(currentPage: atIndex)
        
        self.shouldRefresh = shouldRefresh
    }
}
