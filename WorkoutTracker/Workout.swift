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
    @objc init(type:String, name:String, date:String, exerciseArray:[Exercise]){
        self.type = type
        self.name = name
        self.date = date
        self.exerciseArray = []
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(name, forKey:"name")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(exerciseArray, forKey:  "exercise array")
        aCoder.encodeObject(type, forKey: "type")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.type = aDecoder.decodeObjectForKey("type") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.date = aDecoder.decodeObjectForKey("date") as! String
        self.exerciseArray = aDecoder.decodeObjectForKey("exercise array") as! [Exercise]
    }
}
