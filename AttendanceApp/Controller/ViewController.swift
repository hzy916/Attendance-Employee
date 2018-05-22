//
//  ViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 24/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
           //  currentArray.removeAll()
             currentArray = checkinArray
             collectionView.reloadData()
        case 1:
           //  currentArray.removeAll()
             currentArray = checkoutArray
             collectionView.reloadData()
        default:
            break;
        }
    
    }
    
    
    var checkinArray: [Employee] = []
    var checkoutArray: [Employee] = []
    var currentArray: [Employee] = []
  
    
    
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
    

    
    
    //load employee details from array
    
    func loadEmployeeDetails() -> Array<Employee> {
        
        //Read from plist
        
        var currentArray: [Employee] = []
         if let path = Bundle.main.path(forResource: "Employees", ofType: "plist") {
            if let englishFromPlist = NSArray(contentsOfFile: path) as? [Dictionary<String, Any>] {
                for item in englishFromPlist {
                    let employee = Employee(name: item["name"] as! String, department: item["deparment"] as! String, status: false, inTime: "", outTime: "")
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("user tapped on image # \(checkinArray[indexPath.row])")
        
        let mySignInViewPage: SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
       // mySignInViewPage.selectedImage = self.empArray[indexPath.row]
        
        self.navigationController?.pushViewController(mySignInViewPage, animated: true)
        
        checkoutArray.append(checkinArray[indexPath.row])
        
        //remove employee from check in view
        checkinArray.remove(at:indexPath.row)
        print(checkinArray)
        //add employee to checkout view
        
        print(checkoutArray)
        
        //reload view
        collectionView.reloadData()
    }


    
}
