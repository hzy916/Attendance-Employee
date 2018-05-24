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
    //create image related varibles

    var imagesDirectoryPath:String!
    var signatureImages:[UIImage]!
    var titles:[String]!
    var alerttext = ""
    var selectedEmployee : Employee?
    var isCheckOut = false

////MARK: step 2 Create a delegate property here.
    weak var delegate: ClassBVCDelegate?
    
    
    
    @IBOutlet weak var signInView: UIView!
    var selectedImage:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create the folder for signature images
        var signatureImages : [UIImage] = []
        
        if isCheckOut == true {
            alerttext = "Checked out successfully"
        }
        else {
            alerttext = "Checked in successfully"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //Encoding
        let signImage = UIImage(view: signInView)
        let path = saveImageToDocumentDirectory(signImage)
        print(path)
        
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
            //remove from array
            delegate?.removefromCheckout()
         //   checkoutArray.remove(at:)
        }
        
//        //reload the employee view after they signed
//           collectionView.reloadData()
    }
    //save image to document directory (path)
    func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        let user = ""
        
        let fileName = "\(user)_\(result)"
        
        
        let fullName = fileName.appending(".jpg")
        let filepath = directoryPath.appending(fullName)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: url, options: .atomic)
            return String.init("/Documents/\(fullName)")
            
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

