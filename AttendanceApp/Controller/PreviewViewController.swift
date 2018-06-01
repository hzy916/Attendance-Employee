//
//  PreviewViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 31/05/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

//
//  PreviewViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var reportComposer: ReportComposer!
    
    var HTMLContent: String!
    
    //var reportArray: [Employee] = []
    

    @IBOutlet weak var webPreview: UIWebView!
    
    var reportArray = [[String: String]]()
//    let employeeArray = [employeeName: "hello", reportDate:"2018"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       reportArray  = readReportdata()
        print(reportArray)
    }
   

    let path = NSHomeDirectory()+"/Documents/time.plist"
    var dictionary : NSMutableDictionary!
    let fileManager = FileManager.default
   
    //load employee details from array
    func readReportdata() -> Array<[String: String]> {
        //Read from plist
      
        //let reportFromPlist = NSArray(contentsOfFile: path) as? [Dictionary<String, Any>]
        
       // if let path = Bundle.main.path(forResource: "time", ofType: "plist") {
       //     print(dataFilePath)
        
//        if !fileManager.fileExists(atPath: path) {
//            print("File not exist!")
//
//            let srcPath = Bundle.main.path(forResource: "time", ofType: "plist")
//
//            do {
//                //Copy the project plist file to the documents directory.
//                try fileManager.copyItem(atPath: srcPath!, toPath: path)
//            } catch {
//                print("File copy error!")
//            }
//        }
       
        
        if let reportFromPlist = NSArray(contentsOfFile: path) as? [[String: String]] {
//                for item in reportFromPlist {
//                    //let employeeData = Employee(name: item["name"] as! String, department: item["deparment"] as! String, status: false, inTime: item["checkinTime"] as! String, outTime: item["checkoutTime"]as! String)
//                    reportArray.append(employeeData)
//                    print(employeeData)
//                }
                reportArray = reportFromPlist
            }
       // }
        return reportArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createReportAsHTML()
    }
    
    
    // MARK: IBAction Methods
    

    @IBAction func exportToPDF(_ sender: Any) {
        
    }
    
    
    func createReportAsHTML() {
        reportComposer = ReportComposer()
        if let reportHTML = reportComposer.renderReport(items: reportArray){

            webPreview.loadHTMLString(reportHTML, baseURL: NSURL(string: reportComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = reportHTML
        }
    }
    
    
//    //MARK: FORMATE CURRENT DATE
//    func formatAndGetCurrentDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        return dateFormatter.string(from: Date())
//    }

    
    
}

