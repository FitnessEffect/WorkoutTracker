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
let creatorEmailKey = "creatorEmail"
let clientKey = "client"
let exerciseKey = "exercise"
let opponentKey = "opponent"
let categoryKey = "category"
let creatorID = "creatorID"
let typeKey = "type"
let viewedKey = "viewed"
let weekKey = "week"
let yearKey = "year"
let uploadTimeKey = "time"

class Exercise: NSCoder {
    
    var name:String
    var exerciseDescription:String
    var result:String
    var date:String
    var creatorEmail:String
    var client:String
    var exerciseKey:String
    var opponent:String
    var category:String
    var creatorID:String
    var type:String
    var viewed:String
    var week:String
    var year:String
    var uploadTime:String
    
    //default initializer
    override init(){
        name = ""
        exerciseDescription = ""
        result = ""
        date = ""
        creatorEmail = ""
        opponent = ""
        client = ""
        exerciseKey = ""
        category = ""
        creatorID = ""
        type = ""
        viewed = ""
        year = ""
        week = ""
        uploadTime = ""
    }
    
    //overload initializer
    init(name:String, result:String, description:String, date:String, creatorEmail:String, client:String, exerciseKey:String, opponent:String, category:String, creatorID:String, type:String, viewed:String, year:String, week:String, uploadTime:String){
        self.name = name
        self.exerciseDescription = description
        self.result = result
        self.date = date
        self.creatorEmail = creatorEmail
        self.client = client
        self.exerciseKey = exerciseKey
        self.opponent = opponent
        self.category = category
        self.creatorID = creatorID
        self.type = type
        self.viewed = viewed
        self.year = year
        self.week = week
        self.uploadTime = uploadTime
    }
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        aCoder.encode(name, forKey:"name")
        aCoder.encode(exerciseDescription, forKey: "description")
        aCoder.encode(result, forKey: "result")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(creatorEmail, forKey: "creator")
        aCoder.encode(client, forKey: "client")
        aCoder.encode(exerciseKey, forKey: "exerciseKey")
        aCoder.encode(opponent, forKey: "opponentKey")
        aCoder.encode(category, forKey: "categoryKey")
        aCoder.encode(creatorID, forKey: "creatorID")
        aCoder.encode(type, forKey: "typeKey")
        aCoder.encode(viewed, forKey: "viewedKey")
        aCoder.encode(year, forKey: "year")
        aCoder.encode(week, forKey: "week")
        aCoder.encode(time, forKey: "uploadTime")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.exerciseDescription = aDecoder.decodeObject(forKey: "description") as! String
        self.result = aDecoder.decodeObject(forKey: "result") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.creatorEmail = aDecoder.decodeObject(forKey: "creatorEmail") as! String
        self.client = aDecoder.decodeObject(forKey: "client") as! String
        self.exerciseKey = aDecoder.decodeObject(forKey: "exerciseKey") as! String
        self.opponent = aDecoder.decodeObject(forKey: "opponent") as! String
        self.category = aDecoder.decodeObject(forKey: "category") as! String
        self.creatorID = aDecoder.decodeObject(forKey: "creatorID") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.viewed = aDecoder.decodeObject(forKey: "viewed") as! String
        self.year = aDecoder.decodeObject(forKey: "year") as! String
        self.week = aDecoder.decodeObject(forKey: "week") as! String
        self.uploadTime = aDecoder.decodeObject(forKey: "uploadTime") as! String
    }
}
