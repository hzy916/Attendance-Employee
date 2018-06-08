//
//  PreviewViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 31/05/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//


import UIKit
import MessageUI

class PreviewViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var reportComposer: ReportComposer!
    
    var HTMLContent: String!
    
    @IBOutlet weak var webPreview: UIWebView!
    
    @IBAction func exportToPDF(_ sender: Any) {
//        reportComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        //Check to see the device can send email.
//        if( MFMailComposeViewController.canSendMail() )
//        {
//            print("Can send email.")
//
//            let mailComposer = MFMailComposeViewController()
//            mailComposer.mailComposeDelegate = self
//
//            //Set to recipients
//            mailComposer.setToRecipients(["your email address heres"])
//
//            //Set the subject
//            mailComposer.setSubject("email with document pdf")
//
//            //set mail body
//            mailComposer.setMessageBody("This is what they sound like.", isHTML: true)
//
//            if let filePath = Bundle.main.path(forResource: "report", ofType: "pdf")
//            {
//                print("File path loaded.")
//
//                if let fileData = NSData(contentsOfFile: filePath)
//                {
//                    print("File data loaded.")
//                    mailComposer.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "report.pdf")
//                }
//            }
//
//            //this will compose and present mail to user
//            self.navigationController?.present(mailComposer, animated: true, completion: nil)
//        }
//        else
//        {
//            print("email is not supported")
//        }
        
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
    
    
//    //send email
//    func sendEmail() {
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeViewController = MFMailComposeViewController()
//            mailComposeViewController.setSubject("Invoice")
//            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: reportComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName:"report")
//            present(mailComposeViewController, animated: true, completion: nil)
//        }
//    }
    
    
}

