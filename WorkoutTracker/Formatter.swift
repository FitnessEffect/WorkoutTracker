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
    
//    static func unFormatExerciseDescription(desStr:String) -> String{
//        var stringParts = desStr.components(separatedBy: "\n")
//        var newString:String = ""
//        stringParts.removeFirst()
//        stringParts.removeLast()
//        for index in 0...stringParts.count-1{
//            newString.append(stringParts[index])
//            if index != stringParts.count - 1{
//                newString.append("|")
//            }
//        }
//        return newString
//    }
    
    static func formatExerciseDescription(desStr:String) -> String{
        let stringParts = desStr.components(separatedBy: " | ")
        var newString:String = ""
        newString.append("\n")
        for part in stringParts{
            newString.append(part)
            newString.append("\n")
        }
        return newString
    }
    
    static func formatDurationResult(str:String)->String{
        var formattedStr = ""
        var arr = str.components(separatedBy: " ")

        if arr[0] == "0"{
            if arr[2] == "0"{
                formattedStr = "0 hour(s) 0 min(s)"
            }else{
                formattedStr = arr[2] + " " + arr[3]
            }
        }else if arr[2] == "0"{
            formattedStr = arr[0] + " " + arr[1]
        }else{
            formattedStr = str
        }

        return formattedStr
    }
    
    static func formatResult(str:String)->String{
        var formattedStr = ""
        var arr = str.components(separatedBy: " ")
        //fill in zeros
        if arr[0] == ""{
            arr.insert("0", at: 1)
            arr.remove(at: 0)
        }
        if arr[2] == ""{
            arr.insert("0", at: 3)
            arr.remove(at: 2)
        }
        if arr[4] == ""{
            arr.insert("0", at: 5)
            arr.remove(at: 4)
        }
        
        //hour nil
        if arr[0] == "0"{
            if arr[2] == "0"{
                if arr[4] == "0"{
                    formattedStr = "0 hour(s) 0 min(s) 0 sec(s)"
                }else{
                    formattedStr = arr[4] + " " + arr[5]
                }
            }else{
                if arr[4] == "0"{
                    //only min
                    formattedStr = arr[2] + " " + arr[3]
                }else{
                    //only hour
                    formattedStr = arr[2] + " " + arr[3] + " " + arr[4] + " " + arr[5]
                }
            }
            //hour not nil
        }else{
            if arr[2] == "0"{
                if arr[4] == "0"{
                    //only hour
                    formattedStr = arr[0] + " " + arr[1]
                }else{
                    formattedStr = arr[0] + " " + arr[1] + " " + arr[4] + " " + arr[5]
                }
            }else{
                if arr[4] == "0"{
                    //hr and min
                    formattedStr = arr[0] + " " + arr[1] + " " + arr[2] + " " + arr[3]
                }else{
                    formattedStr = arr[0] + " " + arr[1] + " " + arr[2] + " " + arr[3] + " " + arr[4] + " " + arr[5]
                    
                }
                
            }
        }
        
        return formattedStr
    }
    
    static func changeTimeToSeconds(timeStr:String)->Int{
        var secondsTime = 0
        let tempArr = timeStr.components(separatedBy: " ")
        if tempArr.contains("hour(s)"){
            secondsTime = Int(tempArr[tempArr.index(of: "hour(s)")!-1])!*60*60
        }
        if tempArr.contains("min(s)"){
            
            secondsTime = Int(tempArr[tempArr.index(of: "min(s)")!-1])!*60 + secondsTime
        }
        if tempArr.contains("sec(s)"){
            secondsTime = secondsTime + Int(tempArr[tempArr.index(of: "sec(s)")!-1])!
        }
        return secondsTime
    }
    
    static func changeTimeToDisplayFormat(secondsStr:String)->String{
        var finalStr = ""
        let secondsInt = Int(secondsStr)
        let hours = Int(secondsInt!/60/60)
        if hours != 0{
            finalStr.append("\(hours) hour(s) ")
        }
        let minutes = (secondsInt! % 3600) / 60
        if minutes != 0{
            finalStr.append("\(minutes) min(s) ")
        }
        let seconds =  (secondsInt! % 3600) % 60
        if seconds != 0{
            finalStr.append("\(seconds) sec(s)")
        }
        
        var chars = Array(finalStr)
        if chars.last == " "{
            finalStr.removeAll()
            chars.removeLast()
            for char in chars{
                finalStr.append(char)
            }
        }
        return finalStr
    }
    
    static func changeTimeToSmallDisplayFormat(minutes:Double)->String{
        var finalStr = ""
        let secondsInt = Int(minutes*60)
        let hours = Int(secondsInt/60/60)
        if hours != 0{
            finalStr.append("\(hours)hr ")
        }
        let minutes = (secondsInt % 3600) / 60
        if minutes != 0{
            finalStr.append("\(minutes)m ")
        }
        let seconds =  (secondsInt % 3600) % 60
        if seconds != 0{
            finalStr.append("\(seconds)s")
        }
        
        var chars = Array(finalStr)
        if chars.last == " "{
            finalStr.removeAll()
            chars.removeLast()
            for char in chars{
                finalStr.append(char)
            }
        }
        return finalStr
    }
}
