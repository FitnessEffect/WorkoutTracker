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


class Workout: NSCoder {
    
    var name:String
    var date:String
    var exerciseArray:[Exercise]
    
    
    //default initializer
     override init(){
         name = ""
         date = ""
        exerciseArray = []
    }
    
    //overload initializer
    @objc init(name:String, date:String, exerciseArray:[Exercise]){
        self.name = name
        self.date = date
        self.exerciseArray = []
    }
    
    //initializer that converts a dictionary item to a Client object
//    convenience init(dict:[String:String]){
//        self.init()
//        if let a = dict[workoutNameKey], b = dict[workoutDateKey] {
//            name = a
//            date = b
//        }
//    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(name, forKey:"name")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(exerciseArray, forKey:  "exercise array")
        
    }
    
    
    init (coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.date = aDecoder.decodeObjectForKey("date") as! String
        self.exerciseArray = aDecoder.decodeObjectForKey("exercise array") as! [Exercise]
        
        
    }
}
