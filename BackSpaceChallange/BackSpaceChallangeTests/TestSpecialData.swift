//
//  TestSpecialData.swift
//  BackSpaceChallangeTests
//
//  Created by Gabriel Cortinas on 6/3/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation
import XCTest
@testable import BackSpaceChallange

class MockClientSpecialCharacters: httpProtocols {
    func getMyData(completionHandler: @escaping ([cityData]?) -> Void) {
        let testBundle = Bundle(for: type(of: self))
        let file = testBundle.path(forResource: "special", ofType: "json")
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

class TestSpecialData: XCTestCase {
    
    var dataManager: CityDataMagager?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = CityDataMagager()
        dataManager?.client = MockClientSpecialCharacters()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        CityDataMagager.dict = [:]
        CityDataMagager.currentCitySelected = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testSpecialCharactewrsAvailable() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        self.dataManager?.loadData { (sortedKeys) in
            XCTAssertNotNil(sortedKeys, "we have funkyIndex")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        let firstArray = CityDataMagager.dict.count
        XCTAssertTrue(firstArray == 10)
        CityDataMagager.currentCitySelected = CityDataMagager.dict["Ω"]?.first
        guard let currentCellInfo = self.dataManager?.getCityDetailInformation() else {
            XCTFail()
            return
        }
        guard let filterResult = self.dataManager?.getFilterResult(searchText: "Ωtest") else {
            XCTFail()
            return
        }
        XCTAssertTrue(!currentCellInfo.isEmpty,"we have something starting with Ω")
        XCTAssertTrue(!filterResult.isEmpty, "we found Ωtest")
        
        guard let location = CityDataMagager.currentCitySelected?.location else {
            XCTFail()
            return
        }
        XCTAssertTrue((self.dataManager?.validateLocation(location: location))!,"we have valid location")
        
    }
}
