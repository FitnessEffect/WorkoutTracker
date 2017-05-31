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
let dateKey = "date"
let creatorKey = "creator"
let clientKey = "client"
let exerciseKey = "exerciseKey"
let opponent = "opponentKey"
let category = "categoryKey"

class Exercise: NSCoder {
    
    var name:String
    var exerciseDescription:String
    var result:String
    var date:String
    var creator:String
    var client:String
    var exerciseKey:String
    var opponent:String
    var category:String
    
    //default initializer
    override init(){
        name = ""
        exerciseDescription = ""
        result = ""
        date = ""
        creator = ""
        opponent = ""
        client = ""
        exerciseKey = ""
        category = ""
    }
    
    //overload initializer
    init(name:String, result:String, description:String, date:String, creator:String, client:String, exerciseKey:String, opponent:String, category:String){
        self.name = name
        self.exerciseDescription = description
        self.result = result
        self.date = date
        self.creator = creator
        self.client = client
        self.exerciseKey = exerciseKey
        self.opponent = opponent
        self.category = category
    }
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        aCoder.encode(name, forKey:"name")
        aCoder.encode(exerciseDescription, forKey: "description")
        aCoder.encode(result, forKey: "result")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(creator, forKey: "creator")
        aCoder.encode(creator, forKey: "client")
        aCoder.encode(exerciseKey, forKey: "exerciseKey")
        aCoder.encode(opponent, forKey: "opponentKey")
         aCoder.encode(opponent, forKey: "categoryKey")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.exerciseDescription = aDecoder.decodeObject(forKey: "description") as! String
        self.result = aDecoder.decodeObject(forKey: "result") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.creator = aDecoder.decodeObject(forKey: "creator") as! String
        self.client = aDecoder.decodeObject(forKey: "client") as! String
        self.exerciseKey = aDecoder.decodeObject(forKey: "exerciseKey") as! String
        self.opponent = aDecoder.decodeObject(forKey: "opponentKey") as! String
        self.category = aDecoder.decodeObject(forKey: "categoryKey") as! String
    }
}
