//
//  ViewController.swift
//  mdpa-tinder
//
//  Created by Guillermo Antich Soler on 8/7/18.
//  Copyright © 2018 Guillermo Antich Soler. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import RealmSwift
import Alamofire

class LoginViewController: UIViewController {
    
    var dict : [String : AnyObject]!
    
    var fbLoginSuccess = false
    
    var realm = try! Realm()
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func RegisterButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        if let email = usernameTextField.text, let password = passwordTextField.text {
            if !email.isEmpty && !password.isEmpty {
                let parameters: Parameters = [
                    "email": email,
                    "password": password
                ]
                print("email  \(email), password \(password)")
                
                Alamofire.request("https://mdpa-guillermoantich.azurewebsites.net/api/auth/login", method: .post, parameters: parameters)
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
                            self.performSegue(withIdentifier: "LoginToMain", sender: self)
                        }
                }
            }
        }
    }
    
    @IBAction func btnFBLoginPressed(_ sender: AnyObject) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userBirthday], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
                self.fbLoginSuccess = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Perform Segue from LoginViewController")
        if segue.identifier == "LoginToMain" {
            let destination = segue.destination as! MainTabBarController
        }
        if segue.identifier == "LoginToRegister" {
            let destination = segue.destination as! RegisterViewController
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true)
        {
            self.performSegue(withIdentifier: "LoginToMain", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func getFBUserData(){
        print("getFBUserData called")
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
}

