//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/5/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import Foundation

let exerciseNameKey = "name"
let descriptionKey = "description"
let resultKey = "result"

class Exercise: NSCoder {
    
    var name:String
    var exerciseDescription:String
    var result:String
    
    //default initializer
    override init(){
        name = ""
        exerciseDescription = ""
        result = ""
    }
    
    //overload initializer
    init(name:String, result:String, description:String){
        self.name = name
        self.exerciseDescription = description
        self.result = result
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(name, forKey:"name")
        aCoder.encodeObject(exerciseDescription, forKey: "description")
        aCoder.encodeObject(result, forKey: "result")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.exerciseDescription = aDecoder.decodeObjectForKey("description") as! String
        self.result = aDecoder.decodeObjectForKey("result") as! String
    }
}
