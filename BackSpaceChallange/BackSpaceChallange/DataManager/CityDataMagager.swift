//
//  CityDataMagager.swift
//  BackSpaceChallange
//
//  Created by Gabriel Cortinas on 6/1/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation


struct cityInformation {
    var fullName: String
    var country:String
    var name: String
    var id: Int
    var lon: Double
    var lat: Double
    
    init(completeName:String, city: cityData) {
        fullName = completeName
        name = city.name ?? ""
        country = city.country ?? ""
        id = city._id ?? 0
        lon = city.coord?.lon ?? 0
        lat = city.coord?.lat ?? 0
    }
}

protocol CityDataProtocols {
    
}


class CityDataMagager: CityDataProtocols {
    
    var dict:Dictionary<String, [cityInformation]> = [:]
    
    
    
    func loadData() {
        let client = HTTPClient()
        client.getMyData { (myData) in
            guard let data = myData else { return }
            var fullCityList:Dictionary<String, [cityInformation]> = [:]
            data.forEach({ (cityData) in
                guard let name = cityData.name else { return }
                guard let country = cityData.country else { return }
                let city:cityInformation = cityInformation(completeName: "\(name), \(country)", city: cityData)
                let firstletter = city.fullName.prefix(1)
                let key:String = String(firstletter).uppercased()
                var citiesList: Array<cityInformation> = fullCityList[key] ?? []
                citiesList.append(city)
                fullCityList.updateValue(citiesList, forKey: key)
            })
            self.dict = self.sortCityGroups(groupOfCities: fullCityList)
            print("Number of groups:\(self.dict.count)")
            self.dict.forEach { print("\($0): \($1.count)") }
        }
    }
    
    func sortCityGroups(groupOfCities:Dictionary<String, [cityInformation]>) -> Dictionary<String, [cityInformation]> {
        var sortedGroups:Dictionary<String, [cityInformation]> = [:]
        groupOfCities.forEach { (key,value) in
            let sortedValue = self.sortCities(cityList: value)
            sortedValue.forEach({ (info) in
                print("\(info.fullName) \(info.id)\nlat:\(info.lat) lon:\(info.lon)")
            })
            sortedGroups.updateValue(sortedValue, forKey: key)
        }
        return sortedGroups
    }
    
    func sortCities(cityList:Array<cityInformation>) -> Array<cityInformation> {
        var sortedList = cityList
        sortedList.sort { $0.fullName < $1.fullName}
        return sortedList
    }
    
}
