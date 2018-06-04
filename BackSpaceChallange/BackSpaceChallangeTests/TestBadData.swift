//
//  TestBadData.swift
//  BackSpaceChallangeTests
//
//  Created by Gabriel Cortinas on 6/3/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation
import XCTest
@testable import BackSpaceChallange

class MockClientBadData: httpProtocols {
    func getMyData(completionHandler: @escaping ([cityData]?) -> Void) {
        let testBundle = Bundle(for: type(of: self))
        let file = testBundle.path(forResource: "bad", ofType: "json")
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

class TestBadData: XCTestCase {
    
    var dataManager: CityDataMagager?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = CityDataMagager()
        dataManager?.client = MockClientBadData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        CityDataMagager.dict = [:]
        CityDataMagager.currentCitySelected = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testBadDataAvailable() {
        let expectation = XCTestExpectation(description: "malformed json file")
        self.dataManager?.loadData { (sortedKeys) in
            XCTAssertNil(sortedKeys, "this data is Bad so is empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        let firstArray = CityDataMagager.dict.first
        XCTAssertNil(firstArray,"no info available")
        CityDataMagager.currentCitySelected = firstArray?.value.first
        guard let currentCell = self.dataManager?.getCityDetailInformation() else {
            XCTFail()
            return
        }
        guard let filterResult = self.dataManager?.getFilterResult(searchText: "test") else {
            XCTFail()
            return
        }
        XCTAssertTrue(currentCell.isEmpty,"No info this need to be Empty")
        XCTAssertTrue(filterResult.isEmpty, "No data available")
    }
}
