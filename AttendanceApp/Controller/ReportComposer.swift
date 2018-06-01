//
//  ReportComposer.swift
//  AttendanceApp
//
//  Created by Ziyun He on 31/05/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

//
//  ReportComposer.swift
//  Print2PDF
//
//  Created by Ziyun He on 31/05/2018.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class ReportComposer: NSObject {
    
    override init() {
        super.init()
    }
    
    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "index", ofType: "html")
    
    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
  
    
    let dueDate = ""
    
    let logoImageURL = "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"

//    let fileURL = Bundle.main.url(forResource: "AttitudeTech", withExtension: "png")


    var pdfFilename: String!

//    //Mark get current date
//    func GetCurrentDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        return dateFormatter.string(from: Date())
//    }
//    var reportDate = GetCurrentDate()
//
//    let path = NSHomeDirectory()+"/Documents/time.plist"
//    var dictionary : NSMutableDictionary!
//    let fileManager = FileManager.default
//
    
    func renderReport(items:[[String: String]]) -> String!{
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            
//            // Report date.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: reportDate)
   
            // The employee data will be added by using a loop.
            var allItems = ""

            for i in 0..<items.count {
                var itemHTMLContent: String!
                
                itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                
                print(items[i])
                // Replace the employeename and check data placeholders with the actual values.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_NAME#", with: items[i]["employeeName"]!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CHECKIN_TIME#", with: items[i]["checkInTime"]!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CHECKOUT_TIME#", with: items[i]["checkOutTime"]!)
             
                // Replace the employee signatire with the images.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#IN_SIGNATURE#", with: items[i]["checkOutTime"]!)
                
                // Add the item's HTML code to the general items string.
                allItems += itemHTMLContent
                print(allItems)
            }
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            
            // The HTML code is ready.
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        return nil
    }
    
 

}


