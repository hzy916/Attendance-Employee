//
//  Utility.swift
//  
//
//  Created by Ziyun He on 18/06/2018.
//

import UIKit

class Utility: NSObject {
    func formatAndGetCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: Date())
    }
}
