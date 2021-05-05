//
//  AddCityVCCell.swift
//  OptusJob
//
//  Created by Gary Mansted on 22/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import UIKit

class AddCityVCCell: UITableViewCell {

    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundCardView.layer.cornerRadius = 3.0
        self.backgroundCardView.layer.masksToBounds = false
        self.backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView.layer.shadowOpacity = 0.8
        self.backgroundCardView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.cityNameLabel.textColor = UIColor.white
        self.addButtonOutlet.tintColor = UIColor.white
        self.addButtonOutlet.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
