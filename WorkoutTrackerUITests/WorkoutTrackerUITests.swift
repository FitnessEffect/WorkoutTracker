//
//  WorkoutTrackerUITests.swift
//  WorkoutTrackerUITests
//
//  Created by Stefan Auvergne on 9/30/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import XCTest

class WorkoutTrackerUITests: XCTestCase {
    
    var app:XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        //continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSelectFirstExercise(){
        testLogin()
        app.buttons["Exercise"].tap()
        app.tables.cells["Type0"].tap()
        app.tables.cells["Category0"].tap()
        app.buttons["selectionAID"].tap()
        XCTAssertFalse(app.buttons["Exercise"].exists)
    }
    
    func testLogin() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(app.buttons["Login"].exists)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("stefan@gmail.com")
        app.keyboards.buttons["Return"].tap()
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("testtest\n")
        let exists = NSPredicate(format: "exists == true")
        app.buttons["Login"].tap()
        let exerciseBtn = app.buttons["Exercise"]
        expectation(for: exists, evaluatedWith: exerciseBtn, handler: nil)
        waitForExpectations(timeout: 5,handler: nil)
        XCTAssertTrue(exerciseBtn.exists)
    }
    
}
