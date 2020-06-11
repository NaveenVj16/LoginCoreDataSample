//
//  LoginViewController.swift
//  ExpenseLog
//
//  Created by MAC on 16/05/20.
//  Copyright © 2020 bigyellowfish. All rights reserved.
//

import UIKit
import CoreData

internal class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Userdetails>!
    
    let viewContext = CoreDataManager.shared.persistentContainer.viewContext
    var delegate:ILoginDelegate?
    var viewModal: LoginViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        signInButton.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    func setUpViewModel(viewModel: LoginViewModel) {
        self.viewModal = viewModel
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        guard  usernameTextField.text?.isEmpty == false else {
            showToast(inView: self.view, withMessage: UserMessage.emptyuserName)
            return
        }
        
        guard  passwordTextField.text?.isEmpty == false else {
            showToast(inView: self.view, withMessage: UserMessage.emptyPassword)
            return
        }
       let loginState = viewModal?.validateUserDetails(email: usernameTextField.text!, password: passwordTextField.text!)
    
        if loginState == .validUNamePassword {
            UserDefaults.standard.set(usernameTextField.text!, forKey: UserDefaultKeys.username)
            delegate?.proceedToNextScreen()
            showToast(inView: self.view, withMessage: UserMessage.loginSuccess)
        }else if loginState == .invalidPassword {
            showToast(inView: self.view, withMessage: UserMessage.invalidPassword)
        }else if loginState == .invalidUNamePassword {
            showToast(inView: self.view, withMessage: UserMessage.invalidUNamePassword)
        }
        
        
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        delegate?.showSignUpPage()
    }
    
    
    
}

 extension LoginViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
           
       }
       func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
           
            textField.resignFirstResponder()
       }

       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
          
           textField.resignFirstResponder()
           return true
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
}
