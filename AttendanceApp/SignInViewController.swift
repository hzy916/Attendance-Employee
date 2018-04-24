//
//  SignInViewController.swift
//  AttendanceApp
//
//  Created by Ziyun He on 24/04/2018.
//  Copyright © 2018 Ziyun He. All rights reserved.
//

import UIKit
import TouchDraw

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
    
    
//    //GET THE SIGNITURE
//    func createImage() -> UIImage {
//
//        if #available(iOS 10.0, *) {
//            let renderer = UIGraphicsImageRenderer(bounds: bounds)
//            return renderer.image { rendererContext in
//                layer.render(in: rendererContext.cgContext)
//            }
//        } else {
//            // Fallback on earlier versions
//            let rect: CGRect = self.frame
//
//            UIGraphicsBeginImageContext(rect.size)
//            let context: CGContext = UIGraphicsGetCurrentContext()!
//            self.layer.render(in: context)
//            let img = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            return img!
//        }
//
//    }
    
    let image = UIImage(signInView)

}



extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

