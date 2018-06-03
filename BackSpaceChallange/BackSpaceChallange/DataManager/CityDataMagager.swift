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
    
}


class CityDataMagager: CityDataProtocols {
    
    static let share = CityDataMagager()
    var dict:Dictionary<String, [cityInformation]> = [:]
    var indexList:[String:[String:String]] = [:]
    var currentCitySelected:cityInformation? = nil
    
    
    func loadData(completionHandler: @escaping (_ sortedKeys:[String]?) -> Void) {
        let client = HTTPClient()
        client.getMyData { (myData) in
            guard let data = myData else { return }
            var fullCityList:Dictionary<String, [cityInformation]> = [:]
            data.forEach({ (cityData) in
                //validate information roots you can root out bad data
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
            DispatchQueue.main.async { completionHandler(self.dict.keys.sorted()) }
        }
    }
    
    func sortCityGroups(groupOfCities:[String:[cityInformation]]) -> [String:[cityInformation]] {
        var sortedGroups:Dictionary<String, [cityInformation]> = [:]
        groupOfCities.forEach { (key,value) in
            let sortedValue = self.sortCities(cityList: value)
            sortedGroups.updateValue(sortedValue, forKey: key)
        }
        return sortedGroups
    }
    
    func sortCities(cityList:Array<cityInformation>) -> Array<cityInformation> {
        var sortedList = cityList
        sortedList.sort { $0.fullName < $1.fullName}
        return sortedList
    }
    
    func indexCreator() {
        //add fast search algorith here
        var separayedDict:[String:[String:[cityInformation]]] = [:]
        
        
        self.dict.forEach { (key,value) in
            
            for city in value {
                let index = String.Index.init(encodedOffset: 2)
                let firstletter = city.fullName.prefix(upTo: index)
                
                
            }
            
            
            
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
