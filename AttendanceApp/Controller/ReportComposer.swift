//
//  ReportComposer.swift
//  AttendanceApp
//
//  Created by Ziyun He on 31/05/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//


import UIKit

class ReportComposer: NSObject {
    
    override init() {
        super.init()
        
    }
    //Declare the current date
    let reportDate = Utility.formatAndGetCurrentDate()
    
    let reportDateFormat = Utility.getDate()
    

    
    //Mark: create index.html and single.html in document directory
    
    
    //create index.html and single.html in document directory
    let pathToIndexItemHTML = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("index.html")
    let pathToSingleItemHTML = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("single.html")
  
    //read from html
    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "index", ofType: "html")

    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
//
//    let pathToInvoiceHTMLTemplate = "file://"+NSHomeDirectory()+"/Documents/index.html"
//
//    let pathToSingleItemHTMLTemplate = "file://"+NSHomeDirectory()+"/Documents/single.html"
//
    
//    let imagepath = "/Users/ziyunhe/Documents/iOSStudy/AttendanceApp/AttendanceApp/XMLTemplates/Images/"
    
    let imagepath = NSHomeDirectory()+"/Documents/Images/"
  
    var dictionary : NSMutableDictionary!
    let fileManager = FileManager.default

    //Attitude Tech logo image
    let logourl = "http://pawtrailstest.com/wp-content/uploads/2018/06/AttitudeTech.png"
    

    var pdfFilename: String!
    
    func renderReport(items:[[String: String]]) -> String!{
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
    
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logourl)
            //add the date
            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: reportDate)
            
            // The employee data will be added by using a loop.
            var allItems = ""

            for i in 0..<items.count {
                var itemHTMLContent: String!
                var final_inImagepath: String!
                var final_outImagepath: String!
                
                //get the signature image path to display
                final_inImagepath = imagepath + reportDateFormat + "/" + items[i]["employeeName"]! + "_checkin.jpg"
                final_outImagepath = imagepath + reportDateFormat + "/" + items[i]["employeeName"]! + "_checkout.jpg"
 
                let imageCss = "width=100px;"
                
                let in_imageContent = "<img src='file://" + final_inImagepath + "'" + imageCss + "alt='checkin'>"
                let out_imageContent = "<img src='file://" + final_outImagepath + "'" + imageCss + "alt='checkout'>"
                
                itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_NAME#", with: items[i]["employeeName"]!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CHECKIN_TIME#", with: items[i]["checkInTime"]!)
                
                //Check if employee check out or not, if not, display not check out text in the report
                if items[i]["checkOutTime"]!.isEmpty{
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CHECKOUT_TIME#", with: "no check out")
                    //replace the checkout image with no check out text as well
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#OUT_SIGNATURE#", with: "no check out")
                    
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#Working Hours#", with: "no check out")
                } else{
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CHECKOUT_TIME#", with: items[i]["checkOutTime"]!)
                    
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#OUT_SIGNATURE#", with: out_imageContent)
                    
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#Working Hours#", with: items[i]["workTime"]!)
                }
                // Replace the employee signatire with the images.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#IN_SIGNATURE#", with: in_imageContent)

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
    
 //   function to export html to pdf
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()

        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        let reportDate = Utility.getDate()
        
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/report" + reportDate + ".pdf"
        
        pdfData?.write(toFile: pdfFilename, atomically: true)
        print(pdfFilename)
    }
    
    

    //custom method to draw pdf
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        UIGraphicsBeginPDFPage()
        
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}

