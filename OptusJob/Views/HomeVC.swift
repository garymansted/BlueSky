//
//  HomeVC.swift
//  OptusJob
//
//  Created by Gary Mansted on 22/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireImage

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeVCTableView: UITableView!
    var weatherDetail = Weather()
    var weather = [Weather]()
    var refreshHomeVCTimer : Timer?
    var networkError = false
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        homeVCTableView.dataSource = self
        homeVCTableView.delegate = self
        homeVCTableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHomeVC), name: NSNotification.Name(rawValue: "Refresh_HomeVC"), object: nil)
        UserDefaultsController.getSavedCityIds { [unowned self] (savedCityIds) in
            if savedCityIds.count > 0 {
                DispatchQueue.main.async {
                    let activityIndicator = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
                    activityIndicator?.activityIndicatorColor = ACTIVITY_INDICATOR_SPINNER_COLOR
                }
                NetworkController.getWeatherData(cityIds: savedCityIds,completion: { [unowned self] (error, weatherData) in
                    if error != nil {
                        MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
                        self.displayNetworkErrorMessage()
                    }
                    else {
                        self.weather = weatherData
                        MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
                        self.homeVCTableView.reloadData()
                    }
                })
            }
        }
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        startRefreshTimer(seconds: REFRESH_TIME)
    }
    
    // MARK: - View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        stopRefreshTimer()
    }
    
    // MARK: - Start Refresh Timer
    func startRefreshTimer(seconds: Double) {
        refreshHomeVCTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(refreshHomeVC), userInfo: nil, repeats: true)
    }
    
    // MARK: - Stop Scheduled Data Timer
    func stopRefreshTimer() {
        if refreshHomeVCTimer != nil {
            refreshHomeVCTimer!.invalidate()
            refreshHomeVCTimer = nil
        }
    }
    
    // MARK: - Refresh HomeVC
    @objc func refreshHomeVC() {
        UserDefaultsController.getSavedCityIds { (savedCityIds) in
            if savedCityIds.count > 0 {
                DispatchQueue.main.async { [unowned self] in
                    let activityIndicator = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
                    activityIndicator?.activityIndicatorColor = ACTIVITY_INDICATOR_SPINNER_COLOR
                }
                NetworkController.getWeatherData(cityIds: savedCityIds, completion: { (error, weatherData) in
                    if error != nil {
                        MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
                        self.displayNetworkErrorMessage()
                    }
                    else {
                        self.weather = weatherData
                        MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
                        self.homeVCTableView.reloadData()
                    }
                })
            }
        }
    }
    
    // MARK: - Add City Button
    @IBAction func addCityButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addCitySegue", sender: self)
    }
    
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let detailsVC =  segue.destination as! DetailsVC
            detailsVC.detailsData = weatherDetail
        }
    }

    // MARK: - Status Bar Style Overide Func
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


// END REGION

// MARK: - Extention HomeVC
extension HomeVC {
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeVCCellID") as! HomeVCCell
        cell.cityNameLabel.text = weather[indexPath.row].cityName
        let temperature = TemperatureConverter.tempConverter(temp: weather[indexPath.row].mainTemp)
        cell.temperatureLabel.text = temperature
        cell.mainDetailLabel.text = weather[indexPath.row].weather_main
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherDetail = weather[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! HomeVCCell
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetailSegue", sender: cell)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var index = 0
            UserDefaultsController.getSavedCityIds { [unowned self] (savedCityIds) in
                DispatchQueue.main.async {
                    var cityIds = savedCityIds
                    for id in cityIds {
                        if id == "\(self.weather[indexPath.row].cityId)" {
                            cityIds.remove(at: index)
                        }
                        else {}
                        index += 1
                    }
                    if cityIds.count == 0 {
                        UserDefaultsController.saveNewCityIdEntryies(entries: [])
                    }
                    else {
                        UserDefaultsController.saveNewCityIdEntryies(entries: cityIds)
                    }
                    self.weather.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
     /*
     // code to change cell order 
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         let itemToMove = weather[sourceIndexPath.row]
         weather.remove(at: sourceIndexPath.row)
         weather.insert(itemToMove, at: destinationIndexPath.row)
     }
     */
    
}

