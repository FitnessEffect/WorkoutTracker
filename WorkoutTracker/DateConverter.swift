//
//  DateConverter.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/12/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation

class DateConverter{
    
    static func getCurrentDate() -> String{
        var tempStr = ""
        var monthStr = ""
        var dayStr = ""
        let date = NSDate()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        if month < 10{
            monthStr = "0" + String(month)
        }else{
            monthStr = String(month)
        }
        let day = calendar.component(.day, from: date as Date)
        if day < 10{
            dayStr = "0" + String(day)
        }else{
            dayStr = String(day)
        }
        tempStr = monthStr + "/" + dayStr + "/" + String(year)
        return tempStr
    }
    
    static func getFridayForWeek(selectedDate:NSDate) -> NSDate{
        let calendar = NSCalendar.current
        let weekDay = calendar.component(.weekday, from: selectedDate as Date)
        var daysUntilFriday = 6 - weekDay
        if daysUntilFriday == 0{
            daysUntilFriday = 7
        }
        if daysUntilFriday == -1{
            daysUntilFriday = 6
        }
        let friday:NSDate = selectedDate.addingTimeInterval(TimeInterval(daysUntilFriday*60*60*24))
        return friday
    }
    
    static func getThrusdayForWeek(selectedDate:NSDate) -> NSDate{
        let calendar = NSCalendar.current
        let weekDay = calendar.component(.weekday, from: selectedDate as Date)
        var daysUntilThrusday = 5 - weekDay
        if daysUntilThrusday == -1{
            daysUntilThrusday = 6
        }
        if daysUntilThrusday == -2{
            daysUntilThrusday = 5
        }
        let thrusday:NSDate = selectedDate.addingTimeInterval(TimeInterval(daysUntilThrusday*60*60*24))
        return thrusday
    }
    
    static func getPreviousFridayForWeek(selectedDate:NSDate) -> NSDate{
        let calendar = NSCalendar.current
        let weekDay = calendar.component(.weekday, from: selectedDate as Date)
        var daysUntilPrevFriday = -1 - weekDay
        if daysUntilPrevFriday == -7{
            daysUntilPrevFriday = 0
        }
        if daysUntilPrevFriday == -8{
            daysUntilPrevFriday = -1
        }
        let prevFriday:NSDate = selectedDate.addingTimeInterval(TimeInterval(daysUntilPrevFriday*60*60*24))
        return prevFriday
    }
    
    static func getidFromResponse(selectedDate:NSDate, response:[[String:Any]]) -> Int{
        var weekID = 0
        
        let mSeconds:Double = (selectedDate.timeIntervalSince1970 + Double(NSTimeZone.local.secondsFromGMT()))*1000
        for var dictionary in response{
            let date = dictionary["WeekEndingDate"]
            if mSeconds == Double(DateConverter.convertDateToGMT00(datePassed: date as! String)){
                weekID = dictionary["WeekEndingID"] as! Int
            }
        }
        return weekID
    }
    
    static func convertDateToGMT00(datePassed:String) -> Int64{
        var date = datePassed
        date = date.replacingOccurrences(of: "/", with: "")
        
        var array1 = date.components(separatedBy: "-")
        var array2 = date.components(separatedBy: "+")
        
        //Int64 prevent Iphone 5 overflow crash
        var originalDate:Int64 = 0 //initial date from server in miliseconds
        var miliSeconds = 0 // timezone difference in miliseconds
        var hours = 0
        
        if array1.count == 2{
            let dateString = array1[0]
            let tempArray = dateString.components(separatedBy: "(")
            originalDate = Int64(tempArray[1])!
            let gmt = array1[1]
            var convertedDate = gmt.replacingOccurrences(of: ")", with: "")
            
            if convertedDate.characters.first == "0"{
                let index = convertedDate.index(convertedDate.startIndex, offsetBy: 1)
                hours = Int(convertedDate.substring(from: index))!/100
            }else{
                hours = Int(convertedDate.substring(from: convertedDate.startIndex))!/100
            }
            
            if array2.count == 2{
                let dateString = array2[0]
                let tempArray = dateString.components(separatedBy: "(")
                originalDate = Int64(tempArray[1])!
                
                let gmt = array2[1]
                var convertedDate = gmt.replacingOccurrences(of: ")", with: "")
                if convertedDate.characters.first == "0"{
                    let index = convertedDate.index(convertedDate.startIndex, offsetBy: 1)
                    hours = (Int(convertedDate.substring(from: index))!/100) * -1
                }else{
                    let index = convertedDate.index(convertedDate.startIndex, offsetBy: 0)
                    hours = (Int(convertedDate.substring(from: index))!/100) * -1
                }
            }
        }
        miliSeconds = hours * 3600 * 1000
        let result = (originalDate - Int64(miliSeconds))
        return result
    }
    
    func dateAt00(date:NSDate) -> NSDate{
        let gregorian = NSCalendar.init(calendarIdentifier: .gregorian)
        let components:NSDateComponents = (gregorian?.components([.year, .month, .day, .hour, .minute , .second, .nanosecond], from: date as Date))! as NSDateComponents
        
        components.setValue(0, forComponent: .hour)
        components.setValue(00, forComponent: .minute)
        components.setValue(00, forComponent: .second)
        components.setValue(00, forComponent: .nanosecond)
        
        let newDate:Date = (gregorian?.date(from: components as DateComponents))!
        return newDate as NSDate
    }
    
    static func stringToDate(dateStr:String)->Date{
        var date:Date? = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date = dateFormatter.date(from: dateStr)!
        return date!
    }
    
    static func getNameForDay(entryDate:String)->String{
        //convert string to correct date
        let tempDate = getDateFromUnixString(str: entryDate)
        
        //get date name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: tempDate as Date)
        return dayName
    }
    
    //Method for extracting week for selected day
    func dayIntervalForWeekEnding(date:NSDate)-> String{
        let calendar = NSCalendar.current
        let weekDay = calendar.component(.weekday, from: date as Date)
        let daysUntilPrevSaturday = 0 - weekDay
        let daysUntilFriday = 6 - weekDay
        let prevSaturday:NSDate = date.addingTimeInterval(TimeInterval(daysUntilPrevSaturday*60*60*24))
        let nextFriday:NSDate = date.addingTimeInterval(TimeInterval(daysUntilFriday*60*60*24))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringWithFormat = dateFormatter.string(from: prevSaturday as Date) + " - " + dateFormatter.string(from: nextFriday as Date)
        return stringWithFormat
    }
    
    static func getDateFromUnixString(str:String) -> NSDate{
        let tempArray = str.components(separatedBy: "(")
        let tempArray2 = tempArray[1].components(separatedBy: "-")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let temp = Date(timeIntervalSince1970: Double(tempArray2[0])!/1000)
        return temp as NSDate
    }
    
    static func getMonthFromDate(date:Date) -> Int{
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date as Date)
        return month
    }
}
