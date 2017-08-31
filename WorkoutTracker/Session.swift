//
//  Session.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/29/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation

let exKey = "exercises"
let pKey = "paid"
let cKey = "client"
let durationKey = "duration"
let yrKey = "year"
let weekNumberKey = "weekNumber"
let dayKey = "day"
let keyKey = "key"
let sessionNameKey = "sessionName"
let sessionNumberKey = "sessionNumber"
let clientNameKey = "clientName"

class Session: NSCoder {
    
    var exercises:[String]?
    var paid:Bool
    var duration:Int
    var year:String
    var weekNumber:String
    var day:String
    var key:String
    var sessionName:String
    var sessionNumber:String
    var clientName:String
    
    //default initializer
    override init(){
        exercises = nil
        paid = false
        duration = 0
        year = ""
        weekNumber = ""
        day = ""
        key = ""
        sessionName = ""
        sessionNumber = ""
        clientName = ""
    }
    
    //overload initializer
    init(exercises:[String], paid:Bool, client:Client, duration:Int, year:String, weekNumber:String, day:String, key:String, sessionName:String, sessionNumber:String, clientName:String){
        self.exercises = exercises
        self.paid = paid
        self.duration = duration
        self.year = year
        self.weekNumber = weekNumber
        self.day = day
        self.key = key
        self.sessionName = sessionName
        self.sessionNumber = sessionNumber
        self.clientName = clientName
    }
}
