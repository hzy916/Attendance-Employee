//
//  SignInViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 24/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit
import TouchDraw


class SignInViewController: UIViewController, UIGestureRecognizerDelegate {

    //create image related varibles
    var imagesDirectoryPath:String!
    var signatureImages:[UIImage]!
    var titles:[String]!
    var alerttext = ""
   // create remind text to users to sign
    let remindText = "Please sign before you submit"
    var selectedEmployee : Employee?
    var isCheckOut = false
    
    var employeeArray = [Employee]()
    
//    let reportDate = Utility.getDate()
    //create path to
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("time.plist")
    
    //MARK: label outlet to display employee's name.
    @IBOutlet weak var EmployeeNameLabel: UILabel!
 
    ////MARK: step 2 Create a delegate property here.
    weak var delegate: ClassBVCDelegate?
   
    // make a variable to hold the recognizer
     var tapGesture = UITapGestureRecognizer()
  
    // make a swipe variable to hold the recognizer
    var swipeGesture  = UISwipeGestureRecognizer()
    
    @IBOutlet weak var signInView: TouchDrawView!

    var selectedImage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create the folder for signature images
        var signatureImages : [UIImage] = []
        
//        var ename : String = (selectedEmployee?.employeeName)!
        if isCheckOut == true {
            alerttext = "Checked out successfully"
            //change the navigation bar title to Check Out
            self.title = "Check Out"
            //read and update time.plist
            loadItems()
            updateItems()
        }
        else {
            alerttext = "Checked in successfully"
            //change the navigation bar title to Check In
            self.title = "Check In"
            loadItems()
            employeeArray.append(selectedEmployee!)
//            updateItems()
        }

        //Mark: display the employee's name in the sign in/out view
//        EmployeeNameLabel.text = selectedEmployee!.employeeName
//        //mark: detect users' touch draw in touchdraw view
//
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.myviewTapped(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.numberOfTouchesRequired = 1
//        signInView.addGestureRecognizer(tapGesture)
//        signInView.isUserInteractionEnabled = true
        
        
        //Mark: for swipe gesture
        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SignInViewController.myviewDrawed(_:)))
            signInView.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            signInView.isUserInteractionEnabled = true
            signInView.isMultipleTouchEnabled = true
        }
    }
    
   var isDrawed : Bool = false
//    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
//        print("yes,tapped")
//        isDrawed = true
//    }
    
    //mark: myviewdrawed function
    @objc func myviewDrawed(_ sender : UISwipeGestureRecognizer){
        print("yes,drawed")
        isDrawed = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          EmployeeNameLabel.text = selectedEmployee?.employeeName
    }
 
 
 
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if isDrawed == false{
            let buttonAlert = UIAlertController(title: remindText, message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            buttonAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(buttonAlert, animated: true)
        }else{
        
        //Encoding
        let signImage = UIImage(view: signInView)
        
        //call save to xml folder
        let path = saveImageToXML(signImage)
//        print(path)
        
        let alert = UIAlertController(title: alerttext, message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                //go back to home screen after checked in
                _ = self.navigationController?.popToRootViewController(animated: true)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        self.present(alert, animated: true, completion: nil)
        
        if isCheckOut == true {
            //remove from checkout array
            delegate?.removefromCheckout()

            //Mark:  update the employee object checkin time
            let date = Date()
            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            formatter.dateFormat = "HH:mm"
            let checktime = formatter.string(from: date)
            selectedEmployee?.checkOutTime = checktime
            saveItems()
//            updateItems()
          
        }else{
            //remove from checkin array and add to checkout array
            delegate?.removefromCheckIn()
        
            //Mark:  update the employee object checkin time
            let date = Date()
            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            formatter.dateFormat = "HH:mm"
            let checktime = formatter.string(from: date)
            selectedEmployee?.checkInTime = checktime
            saveItems()
//            updateItems()
        }
    }//end of else mytappedview == true
}

    
      //Mark:  save the employee object checkin time
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(employeeArray)
            try data.write(to:dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                employeeArray = try decoder.decode([Employee].self, from: data)
            }catch{
                print("error decoding item array, \(error)")
            }
        }
    }
    
    //Mark:  update the employee object checkout time
    func updateItems(){
        //find the employee and update the checkouttime
        if let i = employeeArray.index(where: {$0.employeeName == selectedEmployee!.employeeName}){
            print(i)
            print(selectedEmployee?.checkOutTime)
            employeeArray.remove(at: i)
            employeeArray.append(selectedEmployee!)
        }
    }
    

//    //save image to document directory (path)
//    func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
//        let directoryPath =  NSHomeDirectory().appending("/Documents/")
//        print(directoryPath)
//        if !FileManager.default.fileExists(atPath: directoryPath) {
//            do {
//                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
//            } catch {
//                print(error)
//            }
//        }
//
//        //Mark: CheckIn or CheckOut for file name
//       var checkstatusname = ""
//      //Give file name with checkin or checkout
//       if isCheckOut == true {
//        checkstatusname = "checkout"
//      } else {
//        checkstatusname = "checkin"
//       }
//
//        let user = selectedEmployee!.employeeName
//        let fileName = "\(user)_\(checkstatusname)"
//
//
//        let fullName = fileName.appending(".jpg")
//        let filepath = directoryPath.appending(fullName)
//        let url = NSURL.fileURL(withPath: filepath)
//        do {
//            try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: url, options: .atomic)
//            return String.init("/Documents/\(fullName)")
//
//        } catch {
//            print(error)
//            print("file cant not be save at path \(filepath), with error : \(error)");
//            return filepath
//        }
//    }
    
    //Mark: Detect users' touch draw in touchdraw View
    
    
    
    //save image to XML templates
    func saveImageToXML(_ chosenImage: UIImage) -> String {

        let pathToInvoiceHTMLTemplate = "/Users/ziyunhe/Documents/iOSStudy/AttendanceApp/AttendanceApp/XMLTemplates"
        
//        let XMLPath =  pathToInvoiceHTMLTemplate.appending("/Images/")
        
        //create a date folder for signature images everyday
        let reportDate = Utility.getDate()
        let XMLPath =  pathToInvoiceHTMLTemplate.appending("/Images/" + reportDate + "/")
        
        print(XMLPath)
        
        if !FileManager.default.fileExists(atPath: XMLPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: XMLPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        //Mark: CheckIn or CheckOut for file name
        var checkstatusname = ""
        //Give file name with checkin or checkout
        if isCheckOut == true {
            checkstatusname = "checkout"
        } else {
            checkstatusname = "checkin"
        }

        let user = selectedEmployee!.employeeName
        let fileName = "\(user)_\(checkstatusname)"


        let fullName = fileName.appending(".jpg")
        let filepath = XMLPath.appending(fullName)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: url, options: .atomic)
            return String.init("/Images/\(fullName)")

        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
  
    }
}

    // //MARK: step 1 Add Protocol here. to create delegate to pass data between signinview and main viewcontroller view
    protocol ClassBVCDelegate: class {
        func removefromCheckout()
        func removefromCheckIn()
    }


   // get image from given view
    extension UIImage {
        convenience init(view: UIView) {
            UIGraphicsBeginImageContext(view.frame.size)
            view.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.init(cgImage: image!.cgImage!)
        }
    }

