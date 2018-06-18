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
        
//        let formatter = DateFormatter()
//        // initially set the format based on your datepicker date / server String
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let myString = formatter.string(from: Date()) // string purpose I add here
//        // convert your string to date
//        let yourDate = formatter.date(from: myString)
//        //then again set the date format whhich type of output you need
//        formatter.dateFormat = "dd-MMM-yyyy"
//        // again convert your date to string
//        let myStringafd = formatter.string(from: yourDate!)
    }
}
