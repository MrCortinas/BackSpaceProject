//
//  CityDataMagager.swift
//  BackSpaceChallange
//
//  Created by Gabriel Cortinas on 6/1/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation
import MapKit

struct cityInformation {
    var fullName: String
    var country:String
    var name: String
    var id: Int
    var location: CLLocationCoordinate2D
    
    init(completeName:String, city: cityData) {
        fullName = completeName
        name = city.name ?? ""
        country = city.country ?? ""
        id = city._id ?? 0
        location = CLLocationCoordinate2D(latitude: city.coord?.lat ?? 0, longitude: city.coord?.lon ?? 0)
    }
}

protocol CityDataProtocols {
    func loadData(completionHandler: @escaping (_ sortedKeys:[String]?) -> Void)
    func getFilterResult(searchText: String) -> Dictionary<String, [cityInformation]>
    func getFilterMethodAlternative(searchText: String) -> Dictionary<String, [cityInformation]>
    func getCityDetailInformation() -> [(info:String,value:String)]
}


class CityDataMagager: CityDataProtocols {
    
    static let share = CityDataMagager()
    var dict:Dictionary<String, [cityInformation]> = [:]
    var currentCitySelected:cityInformation? = nil
    
    func loadData(completionHandler: @escaping (_ sortedKeys:[String]?) -> Void) {
        let client = HTTPClient()
        DispatchQueue.global(qos: .userInteractive).async {
            client.getMyData { (myData) in
                guard let data = myData else { return }
                var fullCityList:Dictionary<String, [cityInformation]> = [:]
                data.forEach({ (cityData) in
                    //validate information roots you can root out bad data
                    guard let name = cityData.name else { return }
                    guard let country = cityData.country else { return }
                    //create a new sortable value so we can sort by name and country
                    let city:cityInformation = cityInformation(completeName: "\(name), \(country)", city: cityData)
                    //get first character of city so we can separathem by
                    let firstletter = city.fullName.prefix(1)
                    let key:String = String(firstletter).uppercased()
                    //get Array if it exist
                    var citiesList: Array<cityInformation> = fullCityList[key] ?? []
                    //add new city to array to group
                    citiesList.append(city)
                    fullCityList.updateValue(citiesList, forKey: key)
                })
                DispatchQueue.main.async {
                    self.dict = self.sortCityGroups(groupOfCities: fullCityList)
                    completionHandler(self.dict.keys.sorted())
                }
            }
        }
    }
    
    private func sortCityGroups(groupOfCities:[String:[cityInformation]]) -> [String:[cityInformation]] {
        var sortedGroups:Dictionary<String, [cityInformation]> = [:]
        groupOfCities.forEach { (key,value) in
            let sortedValue = self.sortCities(cityList: value)
            sortedGroups.updateValue(sortedValue, forKey: key)
        }
        return sortedGroups
    }
    
    private func sortCities(cityList:Array<cityInformation>) -> Array<cityInformation> {
        var sortedList = cityList
        sortedList.sort { $0.fullName < $1.fullName}
        return sortedList
    }
    
    func getFilterResult(searchText: String) -> Dictionary<String, [cityInformation]> {
        if !searchText.isEmpty {
            let keyLetter = searchText.prefix(1)
            let key:String = String(keyLetter).uppercased()
            let informationArray = self.dict[key]
            guard let filterArray = informationArray?.filter({$0.fullName.starts(with:searchText)}) else { return [:] }
            return [key:filterArray]
        } else {
            return self.dict
        }
    }
    
    func getFilterMethodAlternative(searchText: String) -> Dictionary<String, [cityInformation]> {
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
                    // the contain can also be use if we whant to check if it
                    if str.contains(searchText.uppercased())  {
                        print("found \(searchText) in \(name) for \(information.fullName)")
                        newListofCIties.append(information)
                    }
                }
                })
            return [key:newListofCIties]
        } else {
            return self.dict
        }
    }
    
    
    func getCityDetailInformation() -> [(info:String,value:String)] {
        var listOfDetails:[(info:String,value:String)] = []
        
        if let name = currentCitySelected?.name {
            listOfDetails.append(("City Name",name))
        }
        
        if let country = currentCitySelected?.country {
            listOfDetails.append(("Country",country))
        }
        
        if let id = currentCitySelected?.id {
            listOfDetails.append(("Location ID","\(id)"))
        }
        
        if let location = currentCitySelected?.location {
            listOfDetails.append(("Latitude","\(location.latitude)"))
        }
        
        if let location = currentCitySelected?.location {
            listOfDetails.append(("Longitude","\(location.longitude)"))
        }
        
        return listOfDetails
    }
    
}
