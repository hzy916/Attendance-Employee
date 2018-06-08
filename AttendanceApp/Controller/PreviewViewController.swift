//
//  PreviewViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 31/05/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//


import UIKit
import MessageUI
import SwiftyDropbox

class PreviewViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var reportComposer: ReportComposer!
    
    var HTMLContent: String!
    
    @IBOutlet weak var webPreview: UIWebView!
    
    @IBAction func exportToPDF(_ sender: Any) {
       reportComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
    }
    
    @IBAction func DropboxButtonPressed(_ sender: Any) {
        DropboxbuttonPressed()
    }
    
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
     
    func createReportAsHTML() {
        reportComposer = ReportComposer()
        if let reportHTML = reportComposer.renderReport(items: reportArray){

            webPreview.loadHTMLString(reportHTML, baseURL: NSURL(string: reportComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = reportHTML
        }
    }
    
    
    func DropboxbuttonPressed() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
        // Reference after programmatic auth flow
        let client = DropboxClientsManager.authorizedClient
        
//        let fileData = "testing data example".data(using: String.Encoding.utf8, allowLossyConversion: false)!
//        let reportPath = NSHomeDirectory()+"/Documents/report.plist"
//        let request = client.files.upload(path: reportPath, input: report.fileData)
//            .response { response, error in
//                if let response = response {
//                    print(response)
//                } else if let error = error {
//                    print(error)
//                }
//            }
//            .progress { progressData in
//                print(progressData)
//        }
//        
//        // in case you want to cancel the request
//        if someConditionIsSatisfied {
//            request.cancel()
//        }
//    }
    
    
}

