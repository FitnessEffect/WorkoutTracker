//
//  Formatter.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/22/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation

class Formatter{

    static func formateEmail(email:String) -> String{
        var tempEmail = ""
        tempEmail = email.replacingOccurrences(of: "@", with: "%40")
        tempEmail = tempEmail.replacingOccurrences(of: ".", with: "%2E")
        return tempEmail
    }
    
    static func unFormatExerciseDescription(desStr:String) -> String{
        var stringParts = desStr.components(separatedBy: "\n")
        var newString:String = ""
        stringParts.removeFirst()
        stringParts.removeLast()
        for index in 0...stringParts.count-1{
            newString.append(stringParts[index])
            if index != stringParts.count - 1{
                newString.append("|")
            }
        }
        return newString
    }
    
    static func formatExerciseDescription(desStr:String) -> String{
        let stringParts = desStr.components(separatedBy: "|")
        
        var newString:String = ""
        newString.append("\n")
        for part in stringParts{
            newString.append(part)
            newString.append("\n")
        }
        return newString
    }
}
