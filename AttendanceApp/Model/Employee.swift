//
//  Employee.swift
//  AttendanceApp
//
//  Created by Ziyun He on 25/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import Foundation

class Employee: Codable {
    let employeeName : String
    let departmentName : String
   
    var checkInTime: String
    var checkOutTime: String
    var workTime : String
    
    init(name: String, department: String, inTime: String, outTime: String,workingHours:String){
        employeeName = name
        departmentName = department
     
        checkInTime = inTime
        checkOutTime = outTime
        workTime = workingHours
    }
}



