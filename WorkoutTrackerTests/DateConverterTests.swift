//
//  DateConverterTests.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/29/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Firebase
import XCTest
@testable import WorkoutTracker

class DateConverterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetCurrentDate(){
        let currentDate = WorkoutTracker.DateConverter.getCurrentDate()
        XCTAssertEqual(currentDate, "08/29/2017")
    }
    
    func testGetCurrentYear(){
        let currentYear = WorkoutTracker.DateConverter.getCurrentYear()
        XCTAssertEqual(currentYear, 2017)
    }
    
    func testGetCurrentWeekNum(){
        let weekNum = WorkoutTracker.DateConverter.getCurrentWeekNum()
        XCTAssertEqual(weekNum, 35)
    }
    
    func testConverDateToGMT00(){
        let x = WorkoutTracker.DateConverter.convertDateToGMT00(datePassed: "08/29/2017")
        XCTAssertEqual(x, 0)
    }
    
    func testGetMonthFromDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: "07-29-2017")
        let result = WorkoutTracker.DateConverter.getMonthFromDate(date: date!)
        
        XCTAssertEqual(result, 7)
    }
    
    func testGetSaturdayForWeek(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: "07-29-2017")
        let result = WorkoutTracker.DateConverter.getSaturdayForWeek(selectedDate: date as! NSDate)
        
    }
    
}
