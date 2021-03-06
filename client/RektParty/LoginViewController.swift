//
//  LoginViewController.swift
//  RektParty
//
//  Created by stagiaire on 20/03/2017.
//  Copyright © 2017 The Grilled Birds. All rights reserved.
//

import UIKit
import Alamofire
import JWT

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!

    @IBAction func clickButtonLogin(_ sender: Any) {
        let parameters: Parameters = ["mail": textFieldMail.text!, "password": textFieldPassword.text!]
        Alamofire.request("http://192.168.100.100:4567/login",method: .post, parameters: parameters).responseString { response in

            if let JWTtoken = response.result.value {
                print("JSON: \(JWTtoken)")
                do {
                    // let allo:String = JSON as! String
                    let db = UserDefaults.standard
                    let result = try JWT.decode(JWTtoken, algorithm: .hs256("my$ecretK3y".data(using: .utf8)!))
                    
                    let userData = [
                        "pseudo":result["pseudo"],
                        "birthDate":result["birthDate"],
                        "lastName":result["lastName"],
                        "firstName":result["firstName"],
                        "mail":result["mail"]
                    ]
                    db.set(JWTtoken, forKey: "token")
                    db.set(true, forKey: "isLog")
                    db.set(userData, forKey: "userData")
                    NotificationCenter.default.post(name: Notification.Name("ShowMap"), object: nil, userInfo: nil)
                    self.performSegue(withIdentifier: "mapView", sender: self)
                    
                } catch {
                    print("ERROR TOKEN : \(error)")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickRegister(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerView", sender: self)
    }
    
}

