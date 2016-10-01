//
//  LoginViewController.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/25/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorText: UILabel!
    
    let orion = Orion()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.setNavigationBarHidden(true, animated: false)
        emailText.delegate = self
        passwordText.delegate = self
        clearError()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailText{
            emailText.resignFirstResponder()
            passwordText.becomeFirstResponder()
        }else if textField === passwordText {
            passwordText.resignFirstResponder()
        }
        return true
    }
    
    func clearError() {
        errorText.text = ""
    }
    
    // MARK: Actions
    @IBAction func signInTouched(_ sender: UIButton) {
        clearError()
        if emailText.text?.isEmpty == true || passwordText.text?.isEmpty == true {
            return
        }
        orion.signIn(username: emailText.text!, password: passwordText.text!, onComplete: { data, error -> Void in
            DispatchQueue.main.async(execute: {
                    
                // Internal error making request
                if error != nil {
                    self.errorText.text = "Unable to sign in"
                    return
                }
                
                if data["error"] != nil {
                    print("error ===>\(data["error"])")
                    if let desc = data["error_description"] {
                        print("error_description ===>\(desc)")
                    }
                    // API messages aren't so nice. This is what the web GUI displays.
                    self.errorText.text = "Authentication failure: invalid credentials"
                    return
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "TCInstance") as! TCInstanceTableViewController
                controller.orion = self.orion
                self.navigationController!.setNavigationBarHidden(false, animated: true)
                self.navigationController!.pushViewController(controller, animated: true)
            })
        })
    }
}

