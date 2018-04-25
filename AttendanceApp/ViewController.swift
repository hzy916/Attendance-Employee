//
//  ViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 24/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let mainMenu = ["cow", "dog", "milk", "thank-you"]
    
    override func viewDidLoad() {
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return mainMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.imageCell.image = UIImage(named:mainMenu[indexPath.row])
        cell.lblCell.text = mainMenu[indexPath.row].capitalized
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("user tapped on image # \(mainMenu[indexPath.row])")
        
        let mySignInViewPage: SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        mySignInViewPage.selectedImage = self.mainMenu[indexPath.row]
        
        self.navigationController?.pushViewController(mySignInViewPage, animated: true)
        
    }

    
    
    @IBAction func calculateButton(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        //...
    }
    
}

