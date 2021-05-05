//
//  DetailsVCCell.swift
//  OptusJob
//
//  Created by Gary Mansted on 24/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailsVCCell: UITableViewCell {

    @IBOutlet weak var backgroundCardView_1: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backgroundCardView_3: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundCardView_2: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backgroundCardView_4: UIView!
    @IBOutlet weak var tempMinlabel: UILabel!
    @IBOutlet weak var backgroundCardView_5: UIView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var backgroundCardView_6: UIView!
    @IBOutlet weak var timeLabel: UILabel! // sunrise & sunset
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let transform = CGAffineTransform(translationX: 0, y: self.frame.width)
        let transform_2 = CGAffineTransform(translationX: self.frame.width, y: 0)
        self.backgroundCardView_1.layer.cornerRadius = 4.0
        self.backgroundCardView_1.layer.masksToBounds = false
        self.backgroundCardView_1.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView_1.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView_1.layer.shadowOpacity = 0.8
        self.backgroundCardView_1.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.backgroundCardView_1.alpha = 0
        self.mapView.layer.cornerRadius = 4
        self.mapView.clipsToBounds = true
        self.backgroundCardView_1.transform = transform
        self.cityNameLabel.adjustsFontSizeToFitWidth = true
        self.cityNameLabel.alpha = 0
        self.backgroundCardView_2.layer.cornerRadius = 4.0
        self.backgroundCardView_2.layer.masksToBounds = false
        self.backgroundCardView_2.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView_2.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView_2.layer.shadowOpacity = 0.8
        self.backgroundCardView_2.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.backgroundCardView_2.alpha = 0
        self.backgroundCardView_2.transform = transform_2
        self.backgroundCardView_3.layer.cornerRadius = 4.0
        self.backgroundCardView_3.layer.masksToBounds = false
        self.backgroundCardView_3.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView_3.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView_3.layer.shadowOpacity = 0.8
        self.backgroundCardView_3.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.temperatureLabel.textColor = UIColor.white
        self.descriptionLabel.textColor = UIColor.white
        self.descriptionLabel.adjustsFontSizeToFitWidth = true
        self.backgroundCardView_3.alpha = 0
        self.backgroundCardView_3.transform = transform_2
        self.backgroundCardView_4.layer.cornerRadius = 4.0
        self.backgroundCardView_4.layer.masksToBounds = false
        self.backgroundCardView_4.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView_4.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView_4.layer.shadowOpacity = 0.8
        self.backgroundCardView_4.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.backgroundCardView_4.alpha = 0
        self.backgroundCardView_4.transform = transform_2
        self.backgroundCardView_5.layer.cornerRadius = 4.0
        self.backgroundCardView_5.layer.masksToBounds = false
        self.backgroundCardView_5.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView_5.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView_5.layer.shadowOpacity = 0.8
        self.backgroundCardView_5.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.backgroundCardView_5.alpha = 0
        self.tempMinlabel.textColor = UIColor.white 
        self.tempMaxLabel.textColor = UIColor.white
        self.backgroundCardView_5.transform = transform_2
        self.backgroundCardView_6.layer.cornerRadius = 4.0
        self.backgroundCardView_6.layer.masksToBounds = false
        self.backgroundCardView_6.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView_6.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView_6.layer.shadowOpacity = 0.8
        self.backgroundCardView_6.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.backgroundCardView_6.alpha = 0
        self.backgroundCardView_6.transform = transform_2
        self.timeLabel.textColor = UIColor.white
        self.timeLabel.adjustsFontSizeToFitWidth = true
        self.timeLabel.numberOfLines = 2
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
