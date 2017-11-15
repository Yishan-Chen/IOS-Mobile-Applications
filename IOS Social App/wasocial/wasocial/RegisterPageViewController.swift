//
//  RegisterPageViewController.swift
//  wasocial
//
//  Created by 草我 on 2017/4/9.
//  Copyright © 2017年 陈逸山. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        let repeatPassword = repeatPasswordField.text
        
        //Check for empty
        
        
        if((username?.isEmpty)! || (password?.isEmpty)! || (repeatPassword?.isEmpty)!){
            
            displayMyAlertMessage(AlertMessage: "All fields are required")
            return
        }else if(password != repeatPassword){
            displayMyAlertMessage(AlertMessage: "Passwords don't match")
            return
        }else if(!isValidEmail(testStr: username!)){
            displayMyAlertMessage(AlertMessage: "The email address is badly formatted")
            return
        }else if((password?.characters.count)! < 7){
            displayMyAlertMessage(AlertMessage: "Password is too short!")
            return
        }else{
            // create account
            FIRAuth.auth()?.createUser(withEmail: self.usernameField.text!,password:self.passwordField.text!,completion:{(user,error) in
                if error == nil{
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                }
                else{
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription,preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
        }

//        //Store data
//        UserDefaults.standard.set(username, forKey: "userName")
//        UserDefaults.standard.set(password, forKey: "passWord")
//        UserDefaults.standard.synchronize()
        
        //Display alert message with confirmation
        var myAlert = UIAlertController(title: "Success", message: "Registration is successful, thank you!", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (myAlert) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func displayMyAlertMessage(AlertMessage:String){
        var myAlert = UIAlertController(title: "Alert", message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }

    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
