//
//  NSDate+XM.swift
//  BeautifulApp
//
//  Created by 黄勇 on 15/11/11.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import Foundation

extension NSDate {
    //获取dateFormatter
    class func dateFormatter()->NSDateFormatter {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        return dateFormatter
    }
    
    //获取NSCalendar
    class func calendar()->NSCalendar {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        return calendar
    }
    
    // 获取今天日期
    class func today() -> String{
        let dataFormatter : NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let now : NSDate = NSDate()
        return dataFormatter.stringFromDate(now)
    }
    
    // 判断是否是今天
    class func isToday (dateString : String) -> Bool {
//        let date : String = NSDate.formattDay(dateString)
        return dateString == self.today()
    }
    
    // 判断是否是昨天
    class func isLastDay (dateString : String) -> Bool {
        let todayTimestamp = self.getTimestamp(today())
        let lastdayTimestamp = self.getTimestamp(dateString)
        return lastdayTimestamp == todayTimestamp-(24*60*60)
    }
    
    // yyyy-MM-dd格式 转 MM月dd日
    class func formattDay (dataString : String) -> String {
        if dataString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
            return "errorDate"
        }
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date : NSDate = dateFormatter.dateFromString(dataString)!
        
        
        // 转换成xx月xx日格式
        let newDateFormatter : NSDateFormatter = NSDateFormatter()
        newDateFormatter.dateFormat = "MM月dd日"
        return newDateFormatter.stringFromDate(date)
    }
    
    // 根据日期获取时间戳
    class func getTimestamp (dateString : String) -> NSTimeInterval {
        if dateString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
            return 0
        }
        let newDateStirng = dateString.stringByAppendingString(" 00:00:00")
        
        let formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "Asia/Beijing")
        
        let dateNow = formatter.dateFromString(newDateStirng)
        
        return (dateNow?.timeIntervalSince1970)!
    }
    
    // 获取星期
    class func weekWithDateString (dateString : String) -> String{
        let timestamp = NSDate.getTimestamp(dateString)
        let day = Int(timestamp/86400)
        let array : Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];
        return array[(day-3)%7]
//        return "星期\((day-3)%7))"
    }
    
    //获取当前的年份
    func year()->Int{
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString: String = dateFormatter.stringFromDate(self)
        return Int(yearString)!
    }
    
    //获得当前的月份
    func month()->Int{
        let dateFormatter = NSDate.dateFormatter()
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.stringFromDate(self)
        return Int(monthString)!
    }
    
    //获取当前的日
    func day()->Int{
        let dateFormatter = NSDate.dateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.stringFromDate(self)
        return Int(dayString)!
    }
    
    //获取从当前日期添加dYears的日期
    func dateByAddingYears(dYears: Int)->NSDate{
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = NSDateComponents.init()
        components.year = dYears
        return calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions.WrapComponents)!
    }
    
    //self的月的最后一天
    func dateAtEndOfMonth()->NSDate{
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = calendar.components([.Era, .Month, .Day, .Hour, .Minute, .Second], fromDate: self)
        let range: NSRange = calendar .rangeOfUnit(.Day, inUnit: .Month, forDate: self)
        components.day = range.length
        return calendar.dateFromComponents(components)!
    }
    
}
