//
//  ApplicationCoordinator.swift
//  BYF
//
//  Created by KrishnaRaj on 5/22/19.
//  Copyright © 2019 Kinitous. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

internal class ApplicationCoordinator: Coordinator {
    
    let window: UIWindow
    let navigationController: UINavigationController
    let splashCoordinator: SplashCoordinator
    init(window: UIWindow) {
        self.window = window
        navigationController = NavigationController()
        navigationController.navigationBar.isHidden = true
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
       
        splashCoordinator = SplashCoordinator(navigationController: navigationController)
    }
    
    func start() {
        window.rootViewController = navigationController
        if UserDefaults.standard.string(forKey: UserDefaultKeys.username)?.isEmpty ?? true {
            splashCoordinator.start()
        }else {
            //MARK:Create HomeScreen
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            homeCoordinator.start()
        }
        window.makeKeyAndVisible()
        //        if((DBManager.sharedInstance.fetchCurrentUser() != nil) ){
        //
        //        }
        //        else{
        //          splashCoordinator.start()
        //        }
        
        
    }
}

class NavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool {
//        if (UIDevice.current.orientation == .portrait) {
//
//        }
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
}

