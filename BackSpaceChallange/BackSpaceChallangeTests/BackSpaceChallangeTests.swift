//
//  BackSpaceChallangeTests.swift
//  BackSpaceChallangeTests
//
//  Created by Gabriel Cortinas on 6/1/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import XCTest
@testable import BackSpaceChallange

class MockClient: httpProtocols {
    func getMyData(completionHandler: @escaping ([cityData]?) -> Void) {
        let testBundle = Bundle(for: type(of: self))
        let file = testBundle.path(forResource: "test", ofType: "json")
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

class BackSpaceChallangeTests: XCTestCase {
    
    var dataManager: CityDataMagager?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = CityDataMagager()
        dataManager?.client = MockClient()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        CityDataMagager.dict = [:]
        CityDataMagager.currentCitySelected = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        self.dataManager?.loadData { (sortedKeys) in
            XCTAssertNotNil(sortedKeys, "there data")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        let cityList = CityDataMagager.dict["Z"]
        XCTAssertNotNil(cityList,"there is a city starting wiht Z")
        CityDataMagager.currentCitySelected = cityList?.first
        guard let currentCell = self.dataManager?.getCityDetailInformation() else {
            XCTFail()
            return
        }
        guard let filterResult = self.dataManager?.getFilterResult(searchText: "Zest") else {
            XCTFail()
            return
        }
        XCTAssertFalse(currentCell.isEmpty,"there is place call Zest")
        XCTAssertFalse(filterResult.isEmpty, "we found Zest")
        
        guard let location = CityDataMagager.currentCitySelected?.location else {
            XCTFail()
            return
        }
        
        guard let validLocation = self.dataManager?.validateLocation(location: location) else {
            XCTFail()
            return
        }
        
        XCTAssertFalse(validLocation ,"this location has invalid location")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
