//
//  SignInViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 24/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInView: UIImageView!
    
    var selectedImage:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let imageurl = NSURL(string: self.selectedImage)
        let imageData = NSData(contentsOf: imageurl! as URL)
           if(imageData != nil)
           {
            self.signInView.image = UIImage(data:imageData! as Data)
            }
    }

   

}
