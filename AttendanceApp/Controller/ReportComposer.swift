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
    
    
    let imagepath = "/Users/ziyunhe/Documents/iOSStudy/AttendanceApp/AttendanceApp/XMLTemplates/Images/"
    var dictionary : NSMutableDictionary!
    let fileManager = FileManager.default

    //Attitude Tech logo image
    let imageHTMLContent = "<img src='/Users/ziyunhe/Documents/iOSStudy/AttendanceApp/AttendanceApp/XMLTemplates/AttitudeTech.png' alt='Abhijith_checkout'>"

    var pdfFilename: String!

    func renderReport(items:[[String: String]]) -> String!{
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
    
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            
            // The employee data will be added by using a loop.
            var allItems = ""

            for i in 0..<items.count {
                var itemHTMLContent: String!
                var final_inImagepath: String!
                var final_outImagepath: String!
                
                //get the signature image path to display
                final_inImagepath = imagepath + items[i]["employeeName"]! + "_checkin.jpg"
                final_outImagepath = imagepath + items[i]["employeeName"]! + "_checkout.jpg"
                
                let imageCss = "width=100px;"
                
                let in_imageContent = "<img src='" + final_inImagepath + "'" + imageCss + "alt='checkin'>"
                let out_imageContent = "<img src='" + final_outImagepath + "'" + "alt='checkout'>"
                
                itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                
                print(items[i])
                // Replace the employeename and check data placeholders with the actual values.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_NAME#", with: items[i]["employeeName"]!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CHECKIN_TIME#", with: items[i]["checkInTime"]!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CHECKOUT_TIME#", with: items[i]["checkOutTime"]!)
             
                // Replace the employee signatire with the images.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#IN_SIGNATURE#", with: in_imageContent)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#OUT_SIGNATURE#", with: out_imageContent)

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


