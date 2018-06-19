//
//  Utility.swift
//  AttendanceApp
//
//  Created by Ziyun He on 18/06/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import Foundation

class Utility {
    
    
    class func formatAndGetCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: Date())
    }
    
    class func getDate() -> String {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString:String = dateFormatter.string(from: todaysDate as Date)
        return todayString
    }
}
