//
//  UploadTask.swift
//  AttendanceApp
//
//  Created by Ziyun He on 02/07/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit

class UploadTask: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBackgroundTask()
        doSomeDownload()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    func doSomeDownload() {
        //call endBackgroundTask() on completion..
        switch UIApplication.shared.applicationState {
        case .active:
            print("App is active.")
        case .background:
            print("App is in background.")
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        }
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }

}
