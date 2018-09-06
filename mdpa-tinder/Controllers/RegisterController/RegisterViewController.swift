//
//  RegisterViewController.swift
//  mdpa-tinder
//
//  Created by Guillermo Antich Soler on 8/7/18.
//  Copyright © 2018 Guillermo Antich Soler. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class RegisterViewController: UIViewController {
    
    var realm = try! Realm()
    
    @IBOutlet weak var usernameRegisterTextField: UITextField!
    @IBOutlet weak var emailRegisterTextField: UITextField!
    @IBOutlet weak var passwordRegisterTextField: UITextField!
    
    @IBAction func RegisterButton(_ sender: Any) {
        if let username = usernameRegisterTextField.text, let email = emailRegisterTextField.text, let password = passwordRegisterTextField.text {
            if !email.isEmpty && !password.isEmpty && !username.isEmpty {
                print("Passed !.isEmpty")
                let parameters: Parameters = [
                    "email": email,
                    "password": password,
                    "name" : username
                ]
                
                print("email  \(email), password \(password) name \(username)")
                
                Alamofire.request("https://mdpa-guillermoantich.azurewebsites.net/api/auth/register", method: .post, parameters: parameters)
                    .responseJSON { response in
                        guard response.result.error == nil else {
                            print("error")
                            print(response.result.error!)
                            return
                        }
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        guard let auth = json["auth"] as? Bool else {
                            print("Could not get todo title from JSON")
                            return
                        }
                        print("Passed guard lets")
                        if auth {
                            guard let token = json["token"] as? String else {
                                print("Could not token")
                                return
                            }
                            let user = User()
                            user.token = token
                            user.email = email
                            
                            try! self.realm.write {
                                self.realm.add(user)
                            }
                            print("WTH?")
                            self.performSegue(withIdentifier: "RegisterToMain", sender: self)
                        }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Perform Segue from RegisterViewController")
        if segue.identifier == "RegisterToMain" {
            print("WTH Are u doing?")
            let destination = segue.destination as! MainTabBarController
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


