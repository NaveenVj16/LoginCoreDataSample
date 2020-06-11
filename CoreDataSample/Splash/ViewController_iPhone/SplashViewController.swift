////
////  SplashNewViewController.swift
////  BYF_Lite
////
////  Created by MAC on 03/04/20.
////  Copyright © 2020 Kinitous. All rights reserved.
////

import UIKit
import CoreData

class SplashViewController: UIViewController {

    var viewModal: SplashViewModel?
    
      @IBOutlet weak var getStartedButton: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = getStartedButton.frame.size.height / 2
    }
    
    func setUpViewModel(viewModel: SplashViewModel) {
        self.viewModal = viewModel
    }

   

    
    @IBAction func buttonClicked (_ sender: UIButton) {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController!)
        splashCoordinator.proceedToAppFlow()
            }
    
    
}

