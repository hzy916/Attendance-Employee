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
        
        DropboxbuttonPressed()
    }
    
 
    var reportArray = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
     // Do any additional setup after loading the view.
       reportArray  = readReportdata()
        
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
        
        // Reference after programmatic auth flow
       let client = DropboxClientsManager.authorizedClient
        
//        var clienttest = DropboxClient.init(accessToken: DropboxAccessToken(accessToken:"NeN2J28HT2AAAAAAAAAAMhAMedJUgE2X-ns0degJFv4ekjvAN3PwBUdJ4bVwUZ5K", uid:"UID_NUMBER"))
        
        // Initialize with manually retrieved auth token
//        let client = DropboxClient(accessToken: "NeN2J28HT2AAAAAAAAAAMhAMedJUgE2X-ns0degJFv4ekjvAN3PwBUdJ4bVwUZ5K")
        
        let fileData = "report".data(using: String.Encoding.utf8, allowLossyConversion: false)!
   
        let request = client?.files.upload(path: "/DailyReport/report.pdf", input: fileData)
            .response { response, error in
                if let response = response {
                    print(response)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        
    }
    

    //button to link to dropbox
    @IBAction func didTaplinkButton(_ sender: Any) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
    }
    
 
    
}

