//
//  ChooseCityVC.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/29/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

// MARK:  Protocol

protocol ChooseCityVCDelegate {
    func didAdd(newLocation: WeatherLocation)
}

class ChooseCityVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK:  vars
    var allLocations: [WeatherLocation] = []
    var filteredLocations: [WeatherLocation] = []
    let searchController = UISearchController(searchResultsController: nil)
    var savedLocations: [WeatherLocation]?
    let userDefaults = UserDefaults.standard
    var delegate: ChooseCityVCDelegate?
    
    // MARK:  View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFromUserDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        
        setupTapGesture()
        loadLocationsFromCSV()
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func tableTapped() {
        dismissView()
    }
    
    
    // MARK:  Functions - Get locations
    
    private func loadLocationsFromCSV() {
        if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
            parseCSVAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func parseCSVAt(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",") }) {
                var i = 0
                for line in dataArr {
                    if line.count > 2 && i != 0 {
                        createLocation(line: line)
                    }
                    i += 1
                }
            }
        } catch {
            print("Error reading data CSV", error.localizedDescription)
        }
    }
    
    private func createLocation(line: [String]) {
                                                    //line[0]                                 //line[2]
        let weatherLocation = WeatherLocation(city: line.first!, country: line[1], countryCode: line.last!, isCurrentLocation: false)
        allLocations.append(weatherLocation)
    }
    
    // MARK:  UserDefaults
    
    private func saveToUserDefaults(location: WeatherLocation) {
        if savedLocations != nil {
            if !savedLocations! .contains(location) {
                savedLocations!.append(location)
            }
        } else {
            savedLocations = [location]
        }
        userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    private func loadFromUserDefaults() {
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        }
    }
    
    private func dismissView() {
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true )
        }
    }
}

extension ChooseCityVC: UISearchResultsUpdating {
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredLocations = allLocations.filter({ (location) -> Bool in
            let city = location.city.lowercased().contains(searchText.lowercased())
            let country = location.country.lowercased().contains(searchText.lowercased())
            return city || country
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

extension ChooseCityVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // save location
        tableView.deselectRow(at: indexPath, animated: true)
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
        
        dismissView()
    }
    
}
