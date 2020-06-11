//
//  HomeCoordinator.swift
//  ExpenseLog
//
//  Created by MAC on 16/05/20.
//  Copyright © 2020 bigyellowfish. All rights reserved.
//

import Foundation

import UIKit

internal protocol ILoginDelegate: class {
    func showSignUpPage()
    func proceedToNextScreen()
    func navigateBack()
}

internal class LoginCoordinator : Coordinator {
    
    private let navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel(delegate: self)
        let loginVc = UIStoryboard().loginViewController()
        loginVc.delegate = self
        loginVc.setUpViewModel(viewModel: viewModel)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(loginVc, animated: true)
    }
}

extension LoginCoordinator : ILoginDelegate {
    func showSignUpPage() {
        let signUpVc = UIStoryboard().signUpViewController()
        signUpVc.delegate = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(signUpVc, animated: true)
    }

     func proceedToNextScreen() {
          //MARK:Create HomeScreen
     let homeCoordinator = HomeCoordinator(navigationController: navigationController)
     homeCoordinator.start()
    }
    
    func navigateBack(){
        navigationController.popViewController(animated: true)
    }
   
    
}
