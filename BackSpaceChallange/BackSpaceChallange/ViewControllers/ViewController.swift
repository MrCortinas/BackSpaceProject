 //
//  ViewController.swift
//  BackSpaceChallange
//
//  Created by Gabriel Cortinas on 6/1/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var serachBar: UISearchBar!
    @IBOutlet var loadingScreen: UIView!
    
    
    var cityList:[String] = []
    var cityDict:Dictionary<String, [cityInformation]> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingScreen.isHidden = false
        CityDataMagager.share.loadData { (sortedKeys) in
            guard let keys = sortedKeys else { return }
            self.cityList = keys
            self.cityDict = CityDataMagager.share.dict
            self.loadingScreen.isHidden = true
            self.tableview.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityDict[self.cityList[section]]?.count ?? 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cityList[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cityCell")
        guard let cityData = cityDict[self.cityList[indexPath.section]] else { return cell }
        let currentCity = cityData[indexPath.item]
        cell.textLabel?.text = currentCity.fullName
        cell.detailTextLabel?.text = "Id:\(currentCity.id)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityData = cityDict[self.cityList[indexPath.section]] else { return }
        let currentCity = cityData[indexPath.item]
        CityDataMagager.share.currentCitySelected = currentCity
        performSegue(withIdentifier: "showMapDetails", sender: indexPath)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cityDict = CityDataMagager.share.getFilterResult(searchText: searchText)
        self.cityList = cityDict.keys.sorted()
        self.tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

