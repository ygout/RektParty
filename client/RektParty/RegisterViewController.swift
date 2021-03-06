//
//  RegisterViewController.swift
//  RektParty
//
//  Created by stagiaire on 21/03/2017.
//  Copyright © 2017 The Grilled Birds. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeRegisterModalTouchUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickRegister(_ sender: UIButton) {
        var userData = [String: String]()
        
        if ( self.mail != nil && self.nickName != nil && self.firstName !=  nil
            && self.password != nil && self.birthDate != nil && self.lastName != nil && self.password != nil ) {
            userData["mail"] = self.mail.text!
            userData["password"] = self.password.text!
            userData["pseudo"] = self.nickName.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from:self.birthDate.date)
            userData["birthDate"] = dateString
            userData["firstName"] = self.firstName.text!
            userData["lastName"] = self.lastName.text!
            
            do {
                //Convert to Data
                let jsonData = try! JSONSerialization.data(withJSONObject: userData, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
                Alamofire.request("http://192.168.100.100:4567/register", method: .post, parameters: json)
                    .responseJSON { response in
                        print("Register Succes")   // result of response serialization
                }
                
                let prompt = UIAlertController(title: "Success", message: "Création réussi", preferredStyle: UIAlertControllerStyle.alert)
                self.present(prompt, animated: true,completion: nil)
                prompt.addAction(UIAlertAction(title: "validate", style: .default, handler: { action in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                
            } catch {
                print("JSON Fail")
            }
        }

    }


}
