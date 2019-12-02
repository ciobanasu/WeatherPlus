//
//  AllLocationsTableVC.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/29/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

protocol AllLocationsTableVCDelegate {
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool)
}

class AllLocationsTableVC: UITableViewController {
    
    // MARK:  IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tempSegmentControll: UISegmentedControl!
    
    // MARK:  Vars
    var savedLocations: [WeatherLocation]?
    let userDefaults = UserDefaults.standard
    var weatherData: [CityTempData]?
    var delegate: AllLocationsTableVCDelegate?
    var shouldRefresh = false
    
    // MARK:  View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView

        loadLocationsFromUserdefaults()
        loadTempFromUserDefaults()
        
        setupTapGesture()
    }

     // MARK:  Segment Controll Action
    
    @IBAction func tempSegmentChanged(_ sender: UISegmentedControl) {
        updateTempFormatUserDefaults(newFormat: sender.selectedSegmentIndex)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherDataTVC

        if weatherData != nil {
            cell.configureCell(weatherData: weatherData![indexPath.row])
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.didChooseLocation(atIndex: indexPath.row , shouldRefresh: shouldRefresh)
        self.dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2 && indexPath.row != 3 && indexPath.row != 4
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            
            removeLocationFromSavedLocations(location: locationToDelete!.city)
            tableView.reloadData()
        }
    }
    
    private func removeLocationFromSavedLocations(location: String) {
        if savedLocations != nil {
            for i in 0..<savedLocations!.count {
                let temporaryLocation = savedLocations![i]
                
                if temporaryLocation.city == location {
                    savedLocations!.remove(at: i)
                    saveNewLocationsToUseDefaults()
                    return
                }
            }
        }
    }
    
    // MARK: userdefaults
    
    private func saveNewLocationsToUseDefaults() {
          shouldRefresh = true
          
          userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
          userDefaults.synchronize()
      }
    
    private func loadLocationsFromUserdefaults() {
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
        }
    }
    
    private func updateTempFormatUserDefaults(newFormat: Int) {
         shouldRefresh = true
         userDefaults.set(newFormat, forKey: "Temp")
         userDefaults.synchronize()
     }
     
     private func loadTempFromUserDefaults() {
         if let index = userDefaults.value(forKey: "Temp") {
             tempSegmentControll.selectedSegmentIndex = index as! Int
         } else {
             tempSegmentControll.selectedSegmentIndex = 0
         }
     }
    
    // MARK:  Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSeg" {
            let vc = segue.destination as! ChooseCityVC
            vc.delegate = self
        }
    }
    
    // MARK:  Dismiss
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func tableTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:  Extension

extension AllLocationsTableVC: ChooseCityVCDelegate {
    
    func didAdd(newLocation: WeatherLocation) {
        shouldRefresh = true
        weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
        tableView.reloadData()
    }
    
}
