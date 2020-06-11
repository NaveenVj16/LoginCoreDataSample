//
//  LoginViewModel.swift
//  ExpenseLog
//
//  Created by MAC on 16/05/20.
//  Copyright © 2020 bigyellowfish. All rights reserved.
//

import Foundation

internal enum LoginState {
    case invalidPassword
    case invalidUNamePassword
    case validUNamePassword
}

internal class LoginViewModel {
     var delegate:ILoginDelegate?
    init(delegate:ILoginDelegate) {
        self.delegate = delegate
    }
    func validateUserDetails(email: String, password: String)->LoginState {
        let userDetails = CoreDataManager.shared.fetchUserDetails(withEmail: email)
        
        if userDetails?.email != email {
            return .invalidUNamePassword
        }  else if userDetails?.password != password {
            return .invalidPassword
        }else {
            return .validUNamePassword
        }
         
    }
}
