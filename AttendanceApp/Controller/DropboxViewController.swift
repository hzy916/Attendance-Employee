//
//  DropboxViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 29/06/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        
        // Check if the user is logged in
        // If so, display main employee list view controller
        if DropboxClientsManager.authorizedClient == nil {
            
//            // Display image background view w/logout button
//            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as UIViewController?
//            self.present(mainViewController!, animated: false, completion: nil)
            // Present view to log in
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
        }
    }


    @IBAction func linkButtonPressed(_ sender: Any) {
        // Present view to log in
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
    }
}
