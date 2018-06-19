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

class PreviewViewController: UIViewController, MFMailComposeViewControllerDelegate, UIWebViewDelegate {
    
    var reportComposer: ReportComposer!
    
    var HTMLContent: String!
    
    @IBOutlet weak var webPreview: UIWebView!
    
    
    @IBAction func exportToPDF(_ sender: Any) {
        reportComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        
     //   DropboxbuttonPressed()
    }
    
 
    var reportArray = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the delegate for webView
        webPreview.delegate = self
        
       // Do any additional setup after loading the view.
       reportArray  = readReportdata()
        //create the report and save to pdf format and upload to dropbox
        createReportAsHTML()
        
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
    }
    
    
    // Mark:  set function after webview fully loaded
    func webViewDidFinishLoad(_ webView: UIWebView) {
        reportComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        //after saving the pdf upload to dropbox
        DropboxbuttonPressed()

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
        
        let reportDate = Utility.getDate()
//        let pathforReport = "file://"+NSHomeDirectory()+"/Documents/report.pdf"
        let pathforReport = "file://"+NSHomeDirectory()+"/Documents/report" + reportDate + ".pdf"
        do {
            let data = try Data(contentsOf: URL(string: pathforReport)!)
            // do something with data
            // if the call fails, the catch block is executed
            _ = client?.files.upload(path: "/DailyReport/report" + reportDate + ".pdf", input: data)
                .response { response, error in
                    if let response = response {
                        print(response)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else if let error = error {
                        print(error)
                    }
                }
                .progress { progressData in
                    print(progressData)
            }
        } catch {
            print(error.localizedDescription)
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

