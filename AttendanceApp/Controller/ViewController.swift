//
//  ViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 24/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.


import UIKit
import Foundation
import UserNotifications
import SwiftyDropbox

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,ClassBVCDelegate {

    
    @IBOutlet weak var viewReportButton: UIButton!
    
    
    @IBAction func GotoReport(_ sender: Any) {
        performSegue(withIdentifier: "viewReport", sender: self)
    }

    func removefromCheckout() {
        checkoutArray.remove(at: selectedIndex)
        print(selectedIndex)
        
        //update the employee object checkout time
        collectionView.reloadData()
        //change to default check in list view
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func removefromCheckIn() {
        //remove employee from check in view
        checkoutArray.append(checkinArray[selectedIndex])
        print(checkoutArray)
        checkinArray.remove(at: selectedIndex)
      
        print(checkinArray)

        collectionView.reloadData()
        //change to default check in list view
        segmentedControl.selectedSegmentIndex = 0
    }

    
    //segemented view
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var selectedIndex = 0

    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        changeView()
    }
    
    
    var checkinArray: [Employee] = []
    var checkoutArray: [Employee] = []
    var currentArray: [Employee] = []
    var isCheckOut = false
   
 
    override func viewDidLoad() {
  
        //hide the view report button when the app launch
        viewReportButton.isHidden = true
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        super.viewDidLoad()
        
        //calling the schedule notification time function
        UNUserNotificationCenter.current().delegate = self
        scheduleNotifications()
        
        // Do any additional setup after loading the view, typically from a nib.
         loadEmployeeDetails()
  
        currentArray = checkinArray
        print(checkinArray)
        
        collectionView.reloadData()
        
        //calling function to get report array
        reportArray  = readReportdata()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check if the user is logged in
        // If so, display main employee list view controller
        if DropboxClientsManager.authorizedClient == nil {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
        }
    }
    
    
    func changeView(){
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            //  currentArray.removeAll()
            loadEmployeeDetails()
            currentArray = checkinArray
            collectionView.reloadData()
        case 1:
            //  currentArray.removeAll()
            loadEmployeeDetails()
            currentArray = checkoutArray
            print(checkoutArray)
            collectionView.reloadData()
        default:
            break;
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        changeView()
     
    }
    
    //load employee details from array
    
    func loadEmployeeDetails() {  // -> Array<Employee>
        //Read from plist
        var mainviewArray: [Employee] = []
        var checkedInArray: [Employee] = []
        var checkedOutArray: [Employee] = []
        
        let checkDataPath = NSHomeDirectory()+"/Documents/time.plist"
        if let datafromTimePlist = NSArray(contentsOfFile: checkDataPath) as? [Dictionary<String, Any>] {
            for item in datafromTimePlist {
                let employee = Employee(name: item["employeeName"] as! String, department: item["departmentName"] as! String, inTime: item["checkInTime"] as! String, outTime: item["checkOutTime"] as! String)
                checkedInArray.append(employee)
            }
        }
        
         if let path = Bundle.main.path(forResource: "Employees", ofType: "plist") {
            if let englishFromPlist = NSArray(contentsOfFile: path) as? [Dictionary<String, Any>] {
                for item in englishFromPlist {
                    let employee = Employee(name: item["name"] as! String, department: item["deparment"] as! String, inTime: "", outTime: "")
                    mainviewArray.append(employee)
                }
            }
        }

        //filter the people who didn't check in
        for item in checkedInArray {
            let empCheck = item as Employee
            var count = 0
            for item1 in mainviewArray {
                let emp1 = item1 as Employee
                if (empCheck.employeeName == emp1.employeeName) {
                    mainviewArray.remove(at: count)
                     count -= 1
                }
                count += 1
            }
        }
        
        self.checkinArray = mainviewArray
        
       //filter the employees who checked in and didn't check out
        for item1 in checkedInArray {
            var count = 0
            let emp1 = item1 as Employee
            if (emp1.checkOutTime.isEmpty == true) {
                checkedOutArray.insert(emp1, at: count)
            }
            count += 1
        }
        print(checkedOutArray)
        
        self.checkoutArray = checkedOutArray
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return currentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        let employee = currentArray[indexPath.row] as Employee
        cell.lblCell.text = employee.employeeName
        
        cell.imageCell.image = UIImage(named: employee.employeeName)
        cell.imageCell.layer.cornerRadius = 60
        cell.imageCell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("user tapped on image # \(checkinArray[indexPath.row])")
        selectedIndex = indexPath.row
        print(selectedIndex)
        var mySignInViewPage: SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        // find out check in or check out view to display
        if segmentedControl.selectedSegmentIndex == 1 {
            mySignInViewPage.isCheckOut = true
        } else if segmentedControl.selectedSegmentIndex == 0 {
            mySignInViewPage.isCheckOut = false
        }
       
        //mark: to tell the signinview that the main view is calling the removefromcheckout function
        mySignInViewPage.delegate = self
       
        if segmentedControl.selectedSegmentIndex == 1 {
            mySignInViewPage.selectedEmployee = checkoutArray[selectedIndex]
            
        } else if segmentedControl.selectedSegmentIndex == 0 {
            mySignInViewPage.selectedEmployee = checkinArray[selectedIndex]
        }
        
       // mySignInViewPage.selectedImage = self.empArray[indexPath.row]
        
        self.navigationController?.pushViewController(mySignInViewPage, animated: false)
   
        //reload view
        collectionView.reloadData()
    }
    
    
    //schedule notification functions
    func scheduleNotifications() {
        let content = UNMutableNotificationContent()
        let requestIdentifier = "rajanNotification"
        
        content.badge = 1
        content.title = "Attendance notification"
        content.subtitle = "Daily report is uploaded to Dropbox"
        
        content.categoryIdentifier = "actionCategory"
        content.sound = UNNotificationSound.default()
        

        let calendar = Calendar.current
        let components = DateComponents(hour: 22, minute:00, second: 30) // Set the date here when you want Notification
        let date = calendar.date(from: components)
        
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if error != nil {
                print(error?.localizedDescription)
            }
            print("Notification Register Success")
        }
    }
    
   // declare variables for report
    var reportComposer: ReportComposer!

    var HTMLContent: String!
    var reportArray = [[String: String]]()

    //read from time.plist to get report data
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

    //create report function
    func createReportAsHTML() {
        reportComposer = ReportComposer()
        if let reportHTML = reportComposer.renderReport(items: reportArray){

            HTMLContent = reportHTML
        }
        reportComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
    }
    
    
    //Mark: schedule delete plist daily after upload to dropbox. and delete signature images weekly
//    func deleteFile(){
//        //delete time.plist everyday
//        do {
//            if FileManager.default.fileExists(atPath: pathToPlist) {
//                try FileManager.default.removeItem(atPath: pathToPlist)
//            }
//        } catch {
//            print(error)
//        }
//    }
    
}



extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // some other way of handling notification
        completionHandler([.alert, .sound])
        
        //go to web preview to create html and pdf
         performSegue(withIdentifier: "viewReport", sender: self)
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        completionHandler()
    }
}

