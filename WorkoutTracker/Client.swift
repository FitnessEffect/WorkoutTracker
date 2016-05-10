//
//  Client.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 2/24/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import Foundation

let gender = "gender"
let firstNameKey = "first name"
let lastNameKey = "last name"
let ageKey = "age"
let workoutArrayKey = "workout array"

class Client: NSCoder {
    
    var gender:String
    var firstName:String
    var lastName:String
    var age:String
    var workoutArray:[Workout]
    
    //default initializer
    override init(){
        gender = ""
        firstName = ""
        lastName = ""
        age = ""
        workoutArray = []
    }
    
    //overload initializer
    init(gender:String, firstName:String, lastName:String, age:String, workoutArray:[Workout]){
        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.workoutArray = []
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(gender, forKey: "gender")
        aCoder.encodeObject(firstName, forKey: "first name")
        aCoder.encodeObject(lastName, forKey: "last name")
        aCoder.encodeObject(age, forKey: "age")
        aCoder.encodeObject(workoutArray, forKey:  "workout array")
    }
    
    
    init (coder aDecoder: NSCoder!) {
        self.gender = aDecoder.decodeObjectForKey("gender") as! String
        self.firstName = aDecoder.decodeObjectForKey("first name") as! String
        self.lastName = aDecoder.decodeObjectForKey("last name") as! String
        self.age = aDecoder.decodeObjectForKey("age") as! String
        self.workoutArray = aDecoder.decodeObjectForKey("workout array") as! [Workout]
    }
}
