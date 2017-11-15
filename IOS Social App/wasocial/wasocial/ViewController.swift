//
//  ViewController.swift
//  wasocial
//
//  Created by 陈逸山 on 4/9/17.
//  Copyright © 2017 陈逸山. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        let isUserLogginIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
        
        if(!isUserLogginIn){
            self.performSegue(withIdentifier: "loginView", sender: self);
        }else{
            username.text = UserDefaults.standard.string(forKey: "userName")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profilePhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        var myPicker = UIImagePickerController()
        myPicker.delegate = self
        myPicker.sourceType = .photoLibrary
        present(myPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "loginView", sender: self)
        
    }
    
    
}

