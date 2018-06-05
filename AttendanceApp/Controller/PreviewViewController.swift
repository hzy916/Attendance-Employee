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
    

    @IBOutlet weak var webPreview: UIWebView!
    
    var reportArray = [[String: String]]()

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
        
        if let reportFromPlist = NSArray(contentsOfFile: path) as? [[String: String]] {

                reportArray = reportFromPlist
            }
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

