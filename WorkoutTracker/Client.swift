//
//  Client.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 2/24/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import Foundation

let firstNameKey = "first name"
let lastNameKey = "last name"
let ageKey = "age"
let workoutArrayKey = "workout array"

class Client: NSCoder {
    
    var firstName:String
    var lastName:String
    var age:String
    var workoutArray:[Workout]
    
    
    //default initializer
    override init(){
        firstName = ""
        lastName = ""
        age = ""
        workoutArray = []
        
        
    }
    
    //overload initializer
    init(firstName:String, lastName:String, age:String, workoutArray:[Workout]){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.workoutArray = []
        
}
    
    //initializer that converts a dictionary item to a Client object
//    convenience init(dict:[String:String]){
//        self.init()
//        if let a = dict[firstNameKey], b = dict[lastNameKey], c = dict[age] {
//            firstName = a
//            lastName = b
//            age = c
//            
//        }
//    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(firstName, forKey:"first name")
        aCoder.encodeObject(lastName, forKey: "last name")
        aCoder.encodeObject(age, forKey: "age")
        aCoder.encodeObject(workoutArray, forKey:  "workout array")
    }
    
    
    init (coder aDecoder: NSCoder!) {
        self.firstName = aDecoder.decodeObjectForKey("first name") as! String
        self.lastName = aDecoder.decodeObjectForKey("last name") as! String
        self.age = aDecoder.decodeObjectForKey("age") as! String
        self.workoutArray = aDecoder.decodeObjectForKey("workout array") as! [Workout]
        
        
    }
}
