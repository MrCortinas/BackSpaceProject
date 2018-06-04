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
    func getCityDetailInformation() -> [(info:String,value:String)]
    func validateLocation(location: CLLocationCoordinate2D) -> Bool
}


class CityDataMagager: CityDataProtocols {
    
//    static let share = CityDataMagager()
    static var dict:Dictionary<String, [cityInformation]> = [:]
    static var currentCitySelected:cityInformation? = nil
    var client:httpProtocols = HTTPClient()
    
    func loadData(completionHandler: @escaping (_ sortedKeys:[String]?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.client.getMyData { (myData) in
                guard let data = myData else {
                    completionHandler(nil)
                    return
                }
                var fullCityList:Dictionary<String, [cityInformation]> = [:]
                data.forEach({ (cityData) in
                    if self.validateCityInformation(city: cityData) {
                        //create a new sortable value so we can sort by name and country
                        let city:cityInformation = cityInformation(completeName: "\(cityData.name ?? ""), \(cityData.country ?? "")", city: cityData)
                        //get first character of city so we can separathem by
                        let firstletter = city.fullName.prefix(1)
                        let key:String = String(firstletter).uppercased()
                        //get Array if it exist
                        var citiesList: Array<cityInformation> = fullCityList[key] ?? []
                        //add new city to array to group
                        citiesList.append(city)
                        fullCityList.updateValue(citiesList, forKey: key)
                    }
                })
                DispatchQueue.main.async {
                    CityDataMagager.dict = self.sortCityGroups(groupOfCities: fullCityList)
                    completionHandler(CityDataMagager.dict.keys.sorted())
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
            let informationArray =  CityDataMagager.dict[key]
            guard let filterArray = informationArray?.filter({($0.fullName.uppercased()).starts(with:searchText.uppercased())}) else { return [:] }
            return [key:filterArray]
        } else {
            return  CityDataMagager.dict
        }
    }
    
    func getFilterMethodAlternative(searchText: String) -> Dictionary<String, [cityInformation]> {
        if !searchText.isEmpty {
            var newListofCIties = [cityInformation]()
            let groupIndex = searchText.prefix(1)
            let key:String = String(groupIndex).uppercased()
            let SearchList = CityDataMagager.dict[key]
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
            return  CityDataMagager.dict
        }
    }
    
    func validateLocation(location: CLLocationCoordinate2D) -> Bool {
        //The latitude must be a number between -90 and 90 and the longitude between -180 and 180.
        guard (location.latitude > -90) && (location.latitude < 90) else { return false }
        guard (location.longitude > -180.0) && (location.longitude < 180.0) else { return false }
        return true
    }
    
    private func validateCityInformation(city:cityData) -> Bool {
        //validate information roots you can root out bad data
        guard city.name != nil else { return false}
        guard city.country != nil else { return false}
        return true
    }
    
    func getCityDetailInformation() -> [(info:String,value:String)] {
        var listOfDetails:[(info:String,value:String)] = []
        
        if let name =  CityDataMagager.currentCitySelected?.name {
            listOfDetails.append(("City Name",name))
        }
        
        if let country =  CityDataMagager.currentCitySelected?.country {
            listOfDetails.append(("Country",country))
        }
        
        if let id =  CityDataMagager.currentCitySelected?.id {
            listOfDetails.append(("Location ID","\(id)"))
        }
        
        if let location =  CityDataMagager.currentCitySelected?.location {
            listOfDetails.append(("Latitude","\(location.latitude)"))
        }
        
        if let location =  CityDataMagager.currentCitySelected?.location {
            listOfDetails.append(("Longitude","\(location.longitude)"))
        }
        
        return listOfDetails
    }
    
}
