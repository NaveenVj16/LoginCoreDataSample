//
//  HomeViewController.swift
//  ExpenseLog
//
//  Created by MAC on 16/05/20.
//  Copyright © 2020 bigyellowfish. All rights reserved.
//

import UIKit

internal class HomeViewController: UIViewController {
    
    
      var viewModal: HomeViewModel?
      var delegate:IHomeDelegate?
  
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        
        // Do any additional setup after loading the view.
    }
    
    private func prepareViews(){
        
        userDetailsTableView.delegate = self
        userDetailsTableView.dataSource = self
        logOutButton.layer.cornerRadius = logOutButton.frame.size.height / 2
        logOutButton.applyShadowView(color: UIColor.black, radius: 4, cornerRadius: logOutButton.frame.size.height / 2, alpha: 0.2)
        headerView.applyShadowView(color: UIColor.black, radius: 4, cornerRadius: 0, alpha: 0.2)
        userDetailsTableView.layer.cornerRadius = userDetailsTableView.frame.size.height / 18
        userDetailsTableView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        userDetailsTableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.async {
            self.animateTable()
        }
    }
    
    
    
    func setUpViewModel(viewModel: HomeViewModel) {
        self.viewModal = viewModel
    }
    
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        delegate?.logOut()
    }
    
    
    @IBAction func locationButtonClicked(_ sender: Any) {
        delegate?.showMap()
    }
    
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    //MARK: Tableview Datasources and Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        let   userDetails = CoreDataManager.shared.fetchUserdetailss()?[indexPath.row]
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.username) == userDetails?.email {
             cell.containerVIew.backgroundColor = UIColor.white
        }else {
            cell.containerVIew.backgroundColor = UIColor.white
            
        }
        cell.lblName.text = userDetails?.name
        cell.lblEmail.text = userDetails?.email
        cell.lblDesignation.text = "\(indexPath.row + 1)"
    
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CoreDataManager.shared.fetchUserdetailss()?.count ?? 3
    }
    
   private func animateTable() {
        
        userDetailsTableView.reloadData()
        let cells = userDetailsTableView.visibleCells
        
        let tableViewHeight = userDetailsTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
        
    }
    
}
