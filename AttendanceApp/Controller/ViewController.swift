//
//  ViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 24/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,ClassBVCDelegate {
   
    @IBAction func GotoReport(_ sender: Any) {
        performSegue(withIdentifier: "viewReport", sender: self)
//        sendEmail()
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

        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkinArray = loadEmployeeDetails()
        currentArray = checkinArray
        print(checkinArray)
        
        collectionView.reloadData()
    }
    
    func changeView(){
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            //  currentArray.removeAll()
            currentArray = checkinArray
            collectionView.reloadData()
        case 1:
            //  currentArray.removeAll()
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
    
    func loadEmployeeDetails() -> Array<Employee> {
        //Read from plist
        var currentArray: [Employee] = []
         if let path = Bundle.main.path(forResource: "Employees", ofType: "plist") {
            if let englishFromPlist = NSArray(contentsOfFile: path) as? [Dictionary<String, Any>] {
                for item in englishFromPlist {
                    let employee = Employee(name: item["name"] as! String, department: item["deparment"] as! String, inTime: "", outTime: "")
                    currentArray.append(employee)
                }
            }
        }

       return currentArray
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
        print("user tapped on image # \(checkinArray[indexPath.row])")
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

 
}
