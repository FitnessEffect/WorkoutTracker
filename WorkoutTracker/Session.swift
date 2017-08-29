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
let durationKey = "durationKey"

class Session: NSCoder {
    
    var exercises:[Exercise]
    var paid:Bool
    var client:Client
    var duration:String
    
    //default initializer
    override init(){
        exercises = []
        paid = false
        duration = ""
        client = Client()
    }
    
    //overload initializer
    init(exercises:[Exercise], paid:Bool, client:Client, duration:String){
        self.exercises = exercises
        self.paid = paid
        self.client = client
        self.duration = duration
    }
}
