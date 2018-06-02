//
//  CityDataMagager.swift
//  BackSpaceChallange
//
//  Created by Gabriel Cortinas on 6/1/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation


protocol CityDataProtocols {
    
}


class CityDataMagager: CityDataProtocols {
    
    
    var filterValues = ["A","a","B","b","C","c","D","d","E","e","F","f","G","g","H","h","I","i","J","j","K","k","L","l","M","m","N","n","O","o","P","p","Q","q","R","r","S","s","T","t","U","u","V","v","W","w","X","x","Y","y","Z","z"]
    
    var dict:Dictionary<String, String> = [:]
    
    
    
    func loadData() {
        let client = HTTPClient()
        client.getMyData { (myData) in
            guard let data = myData else { return }
            data.forEach({ (cityData) in
                cityData.name
                
                
                
            })
            
        }
    }
    
    
    
    
    
}
