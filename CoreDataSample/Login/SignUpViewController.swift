//
//  SignUpViewController.swift
//  ExpenseLog
//
//  Created by MAC on 03/06/20.
//  Copyright © 2020 bigyellowfish. All rights reserved.
//

import UIKit
import CoreData

internal class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTextfield: UITextField!
  
     @IBOutlet weak var emailTextfield: UITextField!
    
     @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var delegate:ILoginDelegate?
    var viewModal: LoginViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
         submitButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showToast(inView: self.view, withMessage: error!)
        }
        else {
            // Create cleaned versions of the data
            let userName = userNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            CoreDataManager.shared.createUserdetails(name: userName, email: email, password: password)
            showToast(inView: parent!.view, withMessage: "UserDetails has been created")
            delegate?.navigateBack()
        }
    }
    
   private func validateFields()->String?{
        if userNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
}
