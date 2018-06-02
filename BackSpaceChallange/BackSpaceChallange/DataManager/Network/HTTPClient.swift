//
//  HTTPClient.swift
//  BackSpaceChallange
//
//  Created by Gabriel Cortinas on 6/1/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation

struct cityData : Codable {
    let country:String?
    let name: String?
    let _id: Int?
    let coord: coord?
}

struct coord: Codable {
    let lon: Double
    let lat: Double
}



protocol httpProtocols {
    func getMyData(completionHandler: @escaping (_ jsonData:[cityData]?) -> Void)
}

class HTTPClient: httpProtocols {
    func getMyData(completionHandler: @escaping ([cityData]?) -> Void) {
        let file = Bundle.main.path(forResource: "cities", ofType: "json")
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: file!)) else {
            completionHandler(nil)
            return
        }
        
        if let myData = try? JSONDecoder().decode([cityData].self, from: data) {
            completionHandler(myData)
        } else {
            completionHandler(nil)
        }
        
    }
}
