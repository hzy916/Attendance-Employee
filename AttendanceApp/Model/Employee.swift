//
//  Employee.swift
//  AttendanceApp
//
//  Created by Ziyun He on 25/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import Foundation

class Employee {
    let employeeName : String
    let departmentName : String
    var checkStatus: Bool
    var checkInTime: String
    var checkOutTime: String
    
    init(name: String, department: String, status: Bool,inTime: String, outTime: String ){
        employeeName = name
        departmentName = department
        checkStatus = status
        checkInTime = inTime
        checkOutTime = outTime
    }
}



