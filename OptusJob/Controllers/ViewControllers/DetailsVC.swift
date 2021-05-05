//
//  DetailsVC.swift
//  OptusJob
//
//  Created by Gary Mansted on 22/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import GoogleMaps

class DetailsVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var detailsBackgroundImageView: UIImageView!
    @IBOutlet weak var detailsViewTableView: UITableView!
    var detailsData = Weather()
    private var timer = Timer()
    private var time = ""
    private let dateFormatter = DateFormatter()
    private var hasStartedTimer = false
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsViewTableView.dataSource = self
        detailsViewTableView.delegate = self
        detailsViewTableView.separatorStyle = .none
        detailsViewTableView.isScrollEnabled = false
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "H:mm:ss a"
    }

    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK - Cell Animation 1
    private func cellAnimation_1(cell: DetailsVCCell) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.4, delay: 0, options: [], animations: {
                cell.backgroundCardView_1.alpha = 1
                cell.backgroundCardView_1.transform = .identity
            }, completion: { (true) in
                self.cellAnimation_2(cell: cell)
            })
        }
    }
    
    // MARK - Cell Animation 2
    private func cellAnimation_2(cell: DetailsVCCell) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.4, animations: {
                cell.cityNameLabel.alpha = 1
            }, completion: { (true) in
                self.cellAnimation_3(cell: cell)
            })
        }
    }
    
    // MARK - Cell Animation 3
    private func cellAnimation_3(cell: DetailsVCCell) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: [], animations: {
                cell.backgroundCardView_2.alpha = 1
                cell.backgroundCardView_2.transform = .identity
            }, completion: { (true) in
                self.cellAnimation_4(cell: cell)
            })
        }
    }
    
    // MARK - Cell Animation 4
    private func cellAnimation_4(cell: DetailsVCCell) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.12, options: [], animations: {
                cell.backgroundCardView_3.alpha = 1
                cell.backgroundCardView_3.transform = .identity
            }, completion: { (true) in
                self.cellAnimation_5(cell: cell)

            })
        }
    }
    
    // MARK - Cell Animation 5
    private func cellAnimation_5(cell: DetailsVCCell) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.12, options: [], animations: {
                cell.backgroundCardView_4.alpha = 1
                cell.backgroundCardView_4.transform = .identity
            }, completion: { (true) in
                self.cellAnimation_6(cell: cell)
            })
        }
    }
    
    // MARK - Cell Animation 6
    private func cellAnimation_6(cell: DetailsVCCell) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.12, options: [], animations: {
                cell.backgroundCardView_5.alpha = 1
                cell.backgroundCardView_5.transform = .identity
            }, completion: { (true) in
                self.cellAnimation_7(cell: cell)
            })
        }
    }
    
    // MARK - Cell Animation 7
    private func cellAnimation_7(cell: DetailsVCCell) {
        DispatchQueue.main.async { [unowned self] in
            UIView.animate(withDuration: 0.2, delay: 0.12, options: [], animations: {
                cell.backgroundCardView_6.alpha = 1
                cell.backgroundCardView_6.transform = .identity
            }, completion: { [unowned self] (true) in
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.timerTick) , userInfo: nil, repeats: true)
                self.detailsViewTableView.isScrollEnabled = true
            })
        }
    }
    
    // MARK: - Timer Tick
    @objc private func timerTick() {
        DispatchQueue.main.async { [unowned self] in
            self.time = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
            if self.hasStartedTimer == false {
                self.hasStartedTimer = true
                self.updateNavTitleLabel(theTime: self.time)
            }
            else {
                self.navigationItem.title = self.time
            }
        }
    }

    // MARK: - Animate Title Label
    private func updateNavTitleLabel(theTime: String) {
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.navigationItem.title = theTime
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

}

// END REGION


// MARK: - DetailsVC Extention
extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 510
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsVCCellID") as! DetailsVCCell
        let cityLocation = CLLocation(latitude: detailsData.coordLat, longitude: detailsData.coordLon)
        var deployMarker = GMSMarker()
        deployMarker = GMSMarker(position: cityLocation.coordinate)
        deployMarker.icon = GMSMarker.markerImage(with: .blue)
        deployMarker.map = cell.mapView
        cell.mapView.camera = GMSCameraPosition.camera(withTarget: cityLocation.coordinate, zoom: 3.0)
        cell.cityNameLabel.text = detailsData.cityName
        let icon = detailsData.weather_Icon
        let urlString = "http://openweathermap.org/img/w/\(icon).png"
        cell.iconImageView.af_setImage(withURL: URL(string: urlString)!, placeholderImage: nil, filter: nil, imageTransition: .crossDissolve(0.4))
        let temperature = TemperatureConverter.tempConverter(temp: detailsData.mainTemp)
        cell.temperatureLabel.text = temperature
        cell.descriptionLabel.text = detailsData.weather_Description
        let minTemperature = TemperatureConverter.tempConverter(temp: detailsData.mainTempMin)
        cell.tempMinlabel.text = "Min \(minTemperature)"
        let maxTemperature = TemperatureConverter.tempConverter(temp: detailsData.mainTempMax)
        cell.tempMaxLabel.text = "Max \(maxTemperature)"
        var sunr = Date()
        var suns = Date()
        sunr = Date(timeIntervalSince1970: detailsData.sysSunrise)
        suns = Date(timeIntervalSince1970: detailsData.sysSunset)
        let sunrise = dateFormatter.string(from: sunr)
        let sunset = dateFormatter.string(from: suns)
        cell.timeLabel.text = "Sunrise: \(sunrise)\nSunset: \(sunset)"
        if indexPath.row == 0 {
            cellAnimation_1(cell: cell)
        }
        return cell
    }
    
}



