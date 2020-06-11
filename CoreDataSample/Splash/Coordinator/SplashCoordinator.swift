//
//  SplashCoordinator.swift
//  BYF
//
//  Created by Yasodha on 24/07/19.
//  Copyright © 2019 Kinitous. All rights reserved.
//

import UIKit

protocol SplashViewModelProtocol: class {
    func proceedToAppFlow()

}

internal class SplashCoordinator : Coordinator {
    
    private let navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SplashViewModel()
        viewModel.delegate = self
        let splashVc = UIStoryboard().splashViewController()
        splashVc.setUpViewModel(viewModel: viewModel)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(splashVc, animated: true)
    }
}

extension SplashCoordinator : SplashViewModelProtocol {
    
    func proceedToAppFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
    
   
    
}
