//
//  ProfileTableViewCell.swift
//  BYF_Lite
//
//  Created by MAC on 23/04/20.
//  Copyright © 2020 Kinitous. All rights reserved.
//

import UIKit

internal class ProfileTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var containerVIew: UIView!
    @IBOutlet weak var lblName: UILabel!
      @IBOutlet weak var lblEmail: UILabel!
      @IBOutlet weak var lblDesignation: UILabel!
      @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerVIew.applyShadowView(color: UIColor.black, radius: 3.5, cornerRadius: containerVIew.frame.size.height / 8, alpha: 0.12)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
