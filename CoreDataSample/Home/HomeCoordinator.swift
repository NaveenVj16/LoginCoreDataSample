//
//  HomeCoordinator.swift
//  ExpenseLog
//
//  Created by MAC on 16/05/20.
//  Copyright © 2020 bigyellowfish. All rights reserved.
//

import Foundation

import UIKit

protocol IHomeDelegate: class {
    func showMap()
    func navigateBack()
    func logOut()

}

internal class HomeCoordinator : Coordinator {
    
    private let navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel()
        let homeVC = UIStoryboard().homeViewController()
        homeVC.delegate = self
        homeVC.setUpViewModel(viewModel: viewModel)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(homeVC, animated: true)
    }
}

extension HomeCoordinator : IHomeDelegate {
    func logOut() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
    
    
     func showMap() {

        let mapVC =  UIStoryboard().mapViewController()
        mapVC.delegate = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(mapVC, animated: true)
    }
    
    func navigateBack(){
        navigationController.popViewController(animated: true)
    }
   
    
}
