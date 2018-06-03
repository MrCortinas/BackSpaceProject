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
    
    var cityList:[String] = []
    var cityDict:Dictionary<String, [cityInformation]> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        CityDataMagager.share.loadData { (sortedKeys) in
            guard let keys = sortedKeys else { return }
            print("Number of groups:\(CityDataMagager.share.dict.count)")
            let sortedDict = CityDataMagager.share.dict.sorted { $0.key < $1.key }
            sortedDict.forEach { print("\($0): \($1.count)") }
            self.cityList = keys
            self.cityDict = CityDataMagager.share.dict
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
        if !searchText.isEmpty {
            var newListofCIties = [cityInformation]()
            let groupIndex = searchText.prefix(1)
            let key:String = String(groupIndex).uppercased()
            let SearchList = CityDataMagager.share.dict[key]
            SearchList?.forEach({ (information) in
                let maxIndex = information.fullName.endIndex
                if (searchText.endIndex <= maxIndex) {
                    let name = information.fullName.prefix(upTo: searchText.endIndex)
                    let str = String(name).uppercased()
                    if str.contains(searchText.uppercased())  {
                        print("found \(searchText) in \(name) for \(information.fullName)")
                        newListofCIties.append(information)
                    } else {
                        print("not found \(name)")
                    }
                } else {
                    print("out of index: \(information.fullName)")
                }
//                if name.contains(searchText.lowercased()) {
//                    print("found \(searchText) in \(name)")
//                    newListofCIties.append(information)
//                }
            })
            self.cityDict = [key:newListofCIties]
            self.cityList = [key]
            self.tableview.reloadData()
        } else {
            self.cityDict = CityDataMagager.share.dict
            self.cityList = CityDataMagager.share.dict.keys.sorted()
            self.tableview.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

