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
let activityLevelKey = "activityLevel"
let heightKey = "height"
let weightKey = "weight"
let exercisesKey = "exercise array"
let key = "clientKey"

class Client: NSCoder{
    
    var gender:String
    var firstName:String
    var lastName:String
    var age:String
    var activityLevel:String
    var height:String
    var weight:String
    var exerciseArray:[Exercise]
    var clientKey:String
    
    //default initializer
    override init(){
        gender = ""
        firstName = ""
        lastName = ""
        age = ""
        activityLevel = ""
        height = ""
        weight = ""
        exerciseArray = []
        clientKey = ""
    }
    
    //overload initializer
    init(gender:String, firstName:String, lastName:String, age:String, activityLevel:String, height:String, weight:String, exerciseArray:[Exercise], clientKey:String){
        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.activityLevel = activityLevel
        self.height = height
        self.weight = weight
        self.exerciseArray = []
        self.clientKey = clientKey
    }
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(firstName, forKey: "first name")
        aCoder.encode(lastName, forKey: "last name")
        aCoder.encode(age, forKey: "age")
        aCoder.encode(exerciseArray, forKey:  "exercise array")
        aCoder.encode(clientKey, forKey:  "clientKey")
        aCoder.encode(activityLevel, forKey:  "activityLevelKey")
        aCoder.encode(weight, forKey:  "weightKey")
        aCoder.encode(height, forKey:  "heightKey")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.gender = aDecoder.decodeObject(forKey: "gender") as! String
        self.firstName = aDecoder.decodeObject(forKey: "first name") as! String
        self.lastName = aDecoder.decodeObject(forKey: "last name") as! String
        self.age = aDecoder.decodeObject(forKey: "age") as! String
        self.exerciseArray = aDecoder.decodeObject(forKey: "exercise array") as! [Exercise]
        self.clientKey = aDecoder.decodeObject(forKey: "clientKey") as! String
        self.activityLevel = aDecoder.decodeObject(forKey: "activityLevelKey") as! String
        self.weight = aDecoder.decodeObject(forKey: "weightKey") as! String
        self.height = aDecoder.decodeObject(forKey: "heightKey") as! String
    }
}
