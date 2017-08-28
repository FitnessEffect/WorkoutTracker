//
//  Formatter-Test.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/25/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Firebase
import XCTest
@testable import WorkoutTracker


class Formatter_Test: XCTestCase {
    
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
    
    /**
     * testFormatterEmail
    */
    func testFormatterEmail(){
        let emailStr = "test@gmail.com"
        
        let formattedEmail = WorkoutTracker.Formatter.formateEmail(email: emailStr)
        
        XCTAssertEqual(formattedEmail, "test%40gmail%2Ecom")
    }
    
    func testUnFormatExerciseDescription(){
        let desStr = "Legs\nSquat 1 set(s) 1 rep(s)\n"
        
        let unFormattedString = WorkoutTracker.Formatter.unFormatExerciseDescription(desStr: desStr)
        
        XCTAssertEqual(unFormattedString, "Squat 1 set(s) 1 rep(s)")
    }
    
    func testFormatExerciseDescription(){
        let desStr = "Squat 1 set(s) 1 rep(s)"
        let formattedString = WorkoutTracker.Formatter.formatExerciseDescription(desStr: desStr)
        
        XCTAssertEqual(formattedString, "\nSquat 1 set(s) 1 rep(s)\n")
    }
    
    func testFormateResult(){
        let str = "1 hour(s) 0 min(s) 1 sec(s)"
        let str2 = "1 hour(s) 0 min(s) 0 sec(s)"
        let str3 = "0 hour(s) 1 min(s) 0 sec(s)"
        let str4 = "0 hour(s) 1 min(s) 1 sec(s)"
        let str5 = "1 hour(s) 1 min(s) 1 sec(s)"
        
        let result = WorkoutTracker.Formatter.formatResult(str: str)
        let result2 = WorkoutTracker.Formatter.formatResult(str: str2)
        let result3 = WorkoutTracker.Formatter.formatResult(str: str3)
        let result4 = WorkoutTracker.Formatter.formatResult(str: str4)
        let result5 = WorkoutTracker.Formatter.formatResult(str: str5)
        XCTAssertEqual(result, "1 hour(s) 1 sec(s)")
        XCTAssertEqual(result2, "1 hour(s)")
        XCTAssertEqual(result3, "1 min(s)")
        XCTAssertEqual(result4, "1 min(s) 1 sec(s)")
        XCTAssertEqual(result5, "1 hour(s) 1 min(s) 1 sec(s)")
    }
    
}
