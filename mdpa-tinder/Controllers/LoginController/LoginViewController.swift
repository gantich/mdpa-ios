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

class LoginViewController: UIViewController {
    
    var dict : [String : AnyObject]!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            if !username.isEmpty && !password.isEmpty {
                if (username == "master" || username == "mdpa") && (password == "master" || password == "mdpa"){
                    self.performSegue(withIdentifier: "LoginToMain", sender: self)
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
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Perform Segue from ViewController")
        if segue.identifier == "LoginToMain" {
            let destination = segue.destination as! MainTabBarController
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }*/
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

