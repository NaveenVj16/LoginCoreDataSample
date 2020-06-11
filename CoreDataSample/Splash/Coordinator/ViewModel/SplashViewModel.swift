//
//  SplashViewModel.swift
//  BYF
//
//  Created by Yasodha on 24/07/19.
//  Copyright © 2019 Kinitous. All rights reserved.
//

import Foundation
import UIKit



class SplashViewModel {
    weak var delegate: SplashViewModelProtocol?
    
    init() {
    }
    

    func proceed () {
        self.delegate?.proceedToAppFlow()
    }

}
