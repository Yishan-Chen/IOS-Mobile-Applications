//
//  AddDiaryViewController.swift
//  wasocial
//
//  Created by 草我 on 2017/4/9.
//  Copyright © 2017年 陈逸山. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase


class AddDiaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var sadnessView: DisplayView!
    @IBOutlet weak var neutralView: DisplayView!
    @IBOutlet weak var angerView: DisplayView!
    @IBOutlet weak var happinessView: DisplayView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var surpriseView: DisplayView!
    @IBOutlet weak var fearView: DisplayView!
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    var user: User!
    let ref = FIRDatabase.database().reference(withPath: "diary")
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sadnessView.color = UIColor.blue
        neutralView.color = UIColor.brown
        angerView.color = UIColor.red
        happinessView.color = UIColor.yellow
        surpriseView.color = UIColor.cyan
        fearView.color = UIColor.black
        
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "userName")
        user = User(uid: "0", email: email!)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButton(_ sender: Any) {

        if((titleText.text?.isEmpty)! || contentText.text.isEmpty){
            var myAlert = UIAlertController(title: "Alert", message: "All fields are required!", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        } else {
            var myAlert = UIAlertController(title: "Success", message: "Add diary successfully!", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            let title: String = titleText.text!
            let content: String = contentText.text!
            let diary = Diary(title: title, user: self.user.email, content: content);
            
            
            let diaryRef = self.ref.child(title.lowercased())
            diaryRef.setValue(diary.toAnyObject())
        }
        
    }
    
    
    @IBAction func cameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }

    @IBAction func saveButton(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(AddDiaryViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "image has been saved to your photos." , preferredStyle: .alert
            )
            ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
            present(ac, animated:true, completion:nil)
        } else{
            let ac = UIAlertController(title:"Save error", message: error?.localizedDescription,preferredStyle: .alert)
            ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
            present(ac, animated:true, completion:nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        sendRequest()
        dismiss(animated: true, completion: nil)
    }
    
    public func sendRequest() {
        let head: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "6c128d9215f7415ca319c59f51e13018",
            "Content-Type": "application/octet-stream"
        ]
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)

        let request = Alamofire.upload(imageData!, to: "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize", method: .post, headers: head)
        
        print("\(request)")
        
        request.responseJSON { (response) in
            if let JSON = response.result.value {
                let result = JSON as! [[String:Any]]
                if result.count < 1 {
                    let ac = UIAlertController(title: "Error!", message: "Emotion recoginition failed." , preferredStyle: .alert
                    )
                    ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
                    self.present(ac, animated:true, completion:nil)
                }else{
                    let scores = result[0]["scores"] as! [String:Any]
                    if scores.count < 1 {
                        let ac = UIAlertController(title: "Error!", message: "Emotion recoginition failed." , preferredStyle: .alert
                        )
                        ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
                        self.present(ac, animated:true, completion:nil)
                    }else{
                        print("scores: \(scores)")
                        //                print("anger: \(scores["anger"] as! Double)")
                        let anger = scores["anger"] as! Double
                        let fear = scores["fear"] as! Double
                        let surprise = scores["surprise"] as! Double
                        let happiness = scores["happiness"] as! Double
                        let neutral = scores["neutral"] as! Double
                        let sadness = scores["sadness"] as! Double
                        self.angerView.animateValue(to: CGFloat(anger))
                        self.fearView.animateValue(to: CGFloat(fear))
                        self.surpriseView.animateValue(to: CGFloat(surprise))
                        self.happinessView.animateValue(to: CGFloat(happiness))
                        self.neutralView.animateValue(to: CGFloat(neutral))
                        self.sadnessView.animateValue(to: CGFloat(sadness))
                    }

                }

            }
        }
    }
    
}
