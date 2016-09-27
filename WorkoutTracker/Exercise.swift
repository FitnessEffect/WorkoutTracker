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
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        aCoder.encode(name, forKey:"name")
        aCoder.encode(exerciseDescription, forKey: "description")
        aCoder.encode(result, forKey: "result")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.exerciseDescription = aDecoder.decodeObject(forKey: "description") as! String
        self.result = aDecoder.decodeObject(forKey: "result") as! String
    }
}
