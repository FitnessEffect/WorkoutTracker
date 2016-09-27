//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/5/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import Foundation

let workoutNameKey = "name"
let workoutDateKey = "date"
let exerciseArrayKey = "exercise array"
let workoutTypeKey = "type"
let workoutNumberKey = "number"

class Workout: NSCoder {
    
    var type:String
    var name:String
    var date:String
    var exerciseArray:[Exercise]
    
    
    //default initializer
     override init(){
         type = ""
         name = ""
         date = ""
        exerciseArray = []
    }
    
    //overload initializer
    @objc init(type:String, name:String, date:String, number:Int, exerciseArray:[Exercise]){
        self.type = type
        self.name = name
        self.date = date
        self.exerciseArray = []
    }
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        aCoder.encode(name, forKey:"name")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(exerciseArray, forKey:  "exercise array")
        aCoder.encode(type, forKey: "type")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.exerciseArray = aDecoder.decodeObject(forKey: "exercise array") as! [Exercise]
    }
}
