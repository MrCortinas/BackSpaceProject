//
//  TestNoData.swift
//  BackSpaceChallangeTests
//
//  Created by Gabriel Cortinas on 6/3/18.
//  Copyright © 2018 Gabriel Cortinas. All rights reserved.
//

import Foundation
import XCTest
@testable import BackSpaceChallange

class MockClientNodata: httpProtocols {
    func getMyData(completionHandler: @escaping (_ jsonData:[cityData]?) -> Void) {
        completionHandler(nil)
    }
}

class TestNoData: XCTestCase {
 
    var dataManager: CityDataMagager?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = CityDataMagager()
        dataManager?.client = MockClientNodata() 
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        CityDataMagager.dict = [:]
        CityDataMagager.currentCitySelected = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testNoDataAvailable() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        self.dataManager?.loadData { (sortedKeys) in
            XCTAssertNil(sortedKeys, "there no data")
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
