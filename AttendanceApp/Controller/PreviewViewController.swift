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
        
        DropboxbuttonPressed()
    }
    
 
    
    //Mark: export csv file report
    @IBAction func exportToCSV(_ sender: Any) {
       
        renderCSV(items: reportArray)
    }
    
    //Mark: function to create csv report
    func renderCSV(items:[[String: String]]){
        let reportdate = Utility.getDate()
        let fileName = "report" + reportdate + ".csv"
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "Employee Name,Started, Eneded, Working Time\n"
        
        for i in 0..<items.count {
            
            let newLine = "\(String(describing: items[i]["employeeName"]!)),\(String(describing: items[i]["checkInTime"]!)),\(String(describing: items[i]["checkOutTime"]!)), \(String(describing: items[i]["workTime"]!))\n"
             csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
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
        
        renderCSV(items: reportArray)
        
    }
   
    let pathToPlist = NSHomeDirectory()+"/Documents/time.plist"
    
    var dictionary : NSMutableDictionary!
    let fileManager = FileManager.default
   
    //load employee details from array
    func readReportdata() -> Array<[String: String]> {
        //Read from plist
        if let reportFromPlist = NSArray(contentsOfFile: pathToPlist) as? [[String: String]] {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
           self.navigationController?.popToRootViewController(animated: true)
        }
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

        let pathforReport = "file://"+NSHomeDirectory()+"/Documents/report" + reportDate + ".pdf"
        
        //Upload csv file to Dropbox
        let pathforCSV = "file://"+NSHomeDirectory()+"/tmp/report" + reportDate + ".csv"
  
        //upload report.pdf to dropbox
        do {
            let data = try Data(contentsOf: URL(string: pathforCSV)!)
            // do something with data
            // if the call fails, the catch block is executed
            _ = client?.files.upload(path: "/DailyReport/report" + reportDate + ".csv", input: data)
                .response { response, error in
                    if let response = response {
                        print(response)
 
                        //mark: after upload clear all csv
                        let tempFolderPath = NSHomeDirectory()+"/tmp"
                        do {
                            if FileManager.default.fileExists(atPath: tempFolderPath) {
                                try FileManager.default.removeItem(atPath: tempFolderPath)
                            }
                        } catch {
                            print(error)
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
  
        
        //upload report.pdf to dropbox
        do {
            let data = try Data(contentsOf: URL(string: pathforReport)!)
            // do something with data
            // if the call fails, the catch block is executed
            _ = client?.files.upload(path: "/DailyReport/report" + reportDate + ".pdf", input: data)
                .response { response, error in
                    if let response = response {
                        print(response)
                        //mark: go back to main view controneller
                        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                       // Mark: after upload successfully, clear the data in time.plist
                        do {
                            if FileManager.default.fileExists(atPath: self.pathToPlist) {
                                try FileManager.default.removeItem(atPath: self.pathToPlist)
                            }
                        } catch {
                            print(error)
                        }
                        
                        //mark: after upload clear all the signatures images
                        let tempFolderPath = NSHomeDirectory()+"/Documents/Images"
                        do {
                            if FileManager.default.fileExists(atPath: tempFolderPath) {
                                try FileManager.default.removeItem(atPath: tempFolderPath)
                            }
                        } catch {
                            print(error)
                        }
                        
                        //mark:remove pdf
                        // Create a FileManager instance
                        
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
    


    //Mark: button to connect to Dropbox
    @IBAction func didTaplinkButton(_ sender: Any) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
    }
    
 
    
}

