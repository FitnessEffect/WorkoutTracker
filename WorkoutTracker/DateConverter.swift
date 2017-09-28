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
    
    static func getNameForDay(dateStr:String)->String{
        //convert string to correct date
        let tempDate = stringToDate(dateStr: dateStr)
        
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
    
    static func getMonthFromDate(date:Date) -> Int{
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date as Date)
        return month
    }
    
    static func getCurrentWeekNum()->Int{
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        print(weekOfYear)
        return weekOfYear
    }
    
    static func weekNumFromDate(date:NSDate)->Int{
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: date as Date)
        print(weekOfYear)
        return weekOfYear
    }
    
    static func getDayOfWeek(today:String)->Int {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }
    
    static func yearFromDate(date:NSDate)->Int{
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date as Date)
        print(year)
        return year
    }
    
    static func getCurrentMonth() -> Int{
        let date = NSDate()
        let calendar = NSCalendar.current
        let month = calendar.component(.month, from: date as Date)
        return month
    }
    
    static func getCurrentYear()->Int{
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date.init(timeIntervalSinceNow: 0))
        print(year)
        return year
    }
    
    
    static func getYearFromDate(dateStr:String)->Int{
        let calendar = Calendar.current
        let tempDate = self.stringToDate(dateStr: dateStr)
        let year = calendar.component(.year, from: tempDate)
        print(year)
        return year
    }
    
    static func getWeekNumberFromDate(dateStr:String)->Int{
        let calendar = Calendar.current
        let tempDate = self.stringToDate(dateStr: dateStr)
        let weekNumber = calendar.component(.weekOfYear, from: tempDate)
        print(weekNumber)
        return weekNumber
    }
    
    static func getPreviousSundayForWeek(selectedDate:NSDate) -> NSDate{
        let calendar = NSCalendar.current
        let weekDay = calendar.component(.weekday, from: selectedDate as Date)
        var daysUntilPrevSunday =  1 - weekDay
        if daysUntilPrevSunday == 1{
            daysUntilPrevSunday = -6
        }
        
        let prevFriday:NSDate = selectedDate.addingTimeInterval(TimeInterval(daysUntilPrevSunday*60*60*24))
        return prevFriday
    }
    
    static func getSaturdayForWeek(selectedDate:NSDate) -> NSDate{
        let calendar = NSCalendar.current
        let weekDay = calendar.component(.weekday, from: selectedDate as Date)
        let daysUntilSaturday = 7-weekDay

        let saturday:NSDate = selectedDate.addingTimeInterval(TimeInterval(daysUntilSaturday*60*60*24))
        return saturday
    }
    
    static func getDaysInMonth(monthNum:Int, year:Int) -> Int{
        let calendar = NSCalendar.current
        let dateComponents = DateComponents(year:year, month: monthNum)
        let date = calendar.date(from: dateComponents)
        let range = calendar.range(of: .day, in: .month, for: date!)
        let numOfDays = (range?.count)! as Int
        return numOfDays
    }
    
    static func getCurrentTimeAndDate()->String{
    // Get today date as String
    let date = Date()
    let calender = Calendar.current
    let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
    
    let year = components.year
    let month = components.month
    let day = components.day
    let hour = components.hour
    let minute = components.minute
    let second = components.second
    
    let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
    
    return today_string
    }
}
