//
//  AddCityVC.swift
//  OptusJob
//
//  Created by Gary Mansted on 22/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GoogleMaps
import CoreLocation

class AddCityVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var addCityTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityNameLabelBackgroundView: UIView!
    var cityList = [Weather]()
    var city = Weather()
    var mapViewIsShowing = false
    var locationManager: CLLocationManager! = CLLocationManager()
    var userLocation: CLLocation = CLLocation()
    var deployMarker = GMSMarker()
    var hasLoadedViewOnce = false

    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "AddCityVCCell", bundle: nil)
        addCityTableView.register(nib, forCellReuseIdentifier: "addCityVCCellID")
        addCityTableView.delegate = self
        addCityTableView.dataSource = self
        addCityTableView.separatorStyle = .none
        formatSaveButton()
        formatSearchBar()
        formatMapview()
        cityNameLabel.text = ""
        cityNameLabelBackgroundView.dropShadow()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            displayRestrictedLocationAlert()
        }
        else if CLLocationManager.authorizationStatus() == .restricted {
            displayRestrictedLocationAlert()
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
        let transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        mapView.transform = transform
    }
    
    // MARK: - Format Save Button
    func formatSaveButton() {
        saveButtonOutlet.layer.cornerRadius = 33
        saveButtonOutlet.layer.borderWidth = 1
        saveButtonOutlet.backgroundColor = .lightGray
        saveButtonOutlet.layer.borderColor = UIColor.lightGray.cgColor
        saveButtonOutlet.isEnabled = false
    }
    
    // MARK: - Format Search Bar
    func formatSearchBar() {
        if let sb = searchBar {
            sb.delegate = self
            sb.returnKeyType = .done
            sb.tintColor = UIColor.white
            sb.layer.cornerRadius = 3
            for sView in sb.subviews {
                for ssView in sView.subviews {
                    if ssView.isKind(of: UIButton.self) {
                        let cancelButton = ssView as! UIButton
                        cancelButton.setTitle("Cancel", for: .normal)
                        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)!
                        break
                    }
                }
            }
            let textFieldInsideUISearchBar = sb.value(forKey: "searchField") as? UITextField
            let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
            placeholderLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
            placeholderLabel?.textColor = UIColor.white
        }
    }
    
    // MARK: - Format Mapview
    func formatMapview() {
        mapView.alpha = 0
        mapView.addSubview(saveButtonOutlet)
        cityNameLabelBackgroundView.dropShadow()
        mapView.addSubview(cityNameLabelBackgroundView)
        mapView.addSubview(cityNameLabel)
    }
    
    // MARK: - Map Button
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        if mapViewIsShowing == true {
            mapViewIsShowing = false
            hideMapView()
        }
        else {
            mapViewIsShowing = true
            presentMapView()
        }
    }

    // MARK: - Present MapView
    func presentMapView() {
        DispatchQueue.main.async { [unowned self] in
            if let sb = self.searchBar {
                sb.endEditing(true)
            }
            UIView.animate(withDuration: 0.4, animations: { [unowned self] in
                self.mapView.alpha = 1
                self.mapView.transform = .identity
            }, completion: { (true) in })
        }
    }
    
    // MARK: - Hide MapView
    func hideMapView() {
        let transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        DispatchQueue.main.async { [unowned self] in
            UIView.animate(withDuration: 0.2, animations: {
                self.mapView.transform = transform
                self.mapView.alpha = 0
            }, completion: { (true) in })
        }
    }
    
    // MARK: - MapView DidTapAtCoordinate Delegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.deployMarker.map != nil {
            self.deployMarker.map = nil
        }
        let activityIndicator = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
        activityIndicator?.activityIndicatorColor = ACTIVITY_INDICATOR_SPINNER_COLOR
        if saveButtonOutlet.isEnabled == false {
            saveButtonOutlet.isEnabled = true
            saveButtonOutlet.backgroundColor = MAIN_APP_COLOR
            saveButtonOutlet.layer.borderColor = UIColor.white.cgColor
        }
        deployMarker = GMSMarker(position: coordinate)
        deployMarker.icon = GMSMarker.markerImage(with: .blue)
        deployMarker.map = mapView
        NetworkController.searchByLatAndLon(latitude: "\(coordinate.latitude)", longtitude: "\(coordinate.longitude)") { [unowned self] (cityData) in
            MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
            self.cityList.removeAll()
            self.cityList = cityData
            if self.cityList.count > 0 {
                self.updateCityNameLabel(cityName: self.cityList[0].cityName)
            }
        }
    }
    
    // MARK: - Display Confirm Alert
    func displayConfirmAlert(cityId: String) {
        let alertController = UIAlertController(title: "Confirm Selection", message: "Tap on 'Ok' to confirm your selection", preferredStyle: UIAlertController.Style.alert)
        let button1_action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { [unowned self] (result : UIAlertAction) -> Void in
            self.saveNewCityIdEntry(newEntry: cityId)
        }
        let button2_action = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in }
        alertController.addAction(button1_action)
        alertController.addAction(button2_action)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Update City Name Label
    func updateCityNameLabel(cityName: String) {
        UIView.animate(withDuration: 0.35) { [unowned self] in
            self.cityNameLabel.text = cityName
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Save Button
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if cityList[0].cityName == "" {
            displayCityErrorMessage()
        }
        else {
            saveNewCityIdEntry(newEntry: "\(cityList[0].cityId)")
        }
    }
    
    // MARK: - Save New City Entry
    func saveNewCityIdEntry(newEntry: String) {
        UserDefaultsController.getSavedCityIds { [unowned self] (savedCityIds) in
            var isAlreadyAnEntry = false
            var cityIds = savedCityIds
            for i in savedCityIds {
                if i == newEntry {
                    isAlreadyAnEntry = true
                }
            }
            if isAlreadyAnEntry == true {
                DispatchQueue.main.async { [unowned self] in
                    self.presentAlreadyAddedAlert()
                }
            }
            else {
                cityIds.append(newEntry)
                UserDefaultsController.saveNewCityIdEntryies(entries: cityIds)
                DispatchQueue.main.async { [unowned self] in
                    self.presentSuccessAlert()
                }
            }
        }
    }
    
    // MARK: - Display Already Added Alert
    func presentAlreadyAddedAlert() {
        let alertController = UIAlertController(title: "Already Added", message: "You have already added this city.\nPlease search again", preferredStyle: UIAlertController.Style.alert)
        let button1_action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { [unowned self] (result : UIAlertAction) -> Void in
            self.cityList.removeAll()
            if let sb = self.searchBar {
                sb.endEditing(true)
                sb.text = ""
            }
            self.addCityTableView.reloadData()
            self.updateCityNameLabel(cityName: "")
            if self.deployMarker.map != nil {
                self.deployMarker.map = nil
            }
            self.saveButtonOutlet.backgroundColor = .lightGray
            self.saveButtonOutlet.layer.borderColor = UIColor.lightGray.cgColor
            self.saveButtonOutlet.isEnabled = false
        }
        alertController.addAction(button1_action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Display Save Success Alert
    func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Saved", message: "Save Success!", preferredStyle: UIAlertController.Style.alert)
        let button1_action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { [unowned self] (result : UIAlertAction) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "Refresh_HomeVC"), object: nil)
            self.closeVC()
        }
        alertController.addAction(button1_action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Location Manager Delegate Methods -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLoc:AnyObject = locations[locations.count - 1]
        userLocation = CLLocation(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)
        if hasLoadedViewOnce == true {}
        else {
            hasLoadedViewOnce = true
            mapView.camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: 10.0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("Location Error: " + (error?.localizedDescription)!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorized:
            print("authorized")
        case .authorizedWhenInUse:
            mapView.delegate = self
            mapView.isMyLocationEnabled = true
            locationManager.startUpdatingLocation()
        case .denied:
            displayRestrictedLocationAlert()
        case .notDetermined:
            print("not determined")
        case .restricted:
            displayRestrictedLocationAlert()
        default:
            print("ERROR")
        }
    }
    
    // MARK: - Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let sb = self.searchBar {
            sb.endEditing(true)
        }
    }
    
    // MARK: - Close Button
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        closeVC()
    }
    
    func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
}

// END REGION


// MARK: - Extention AddCityVC
extension AddCityVC {
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCityVCCellID") as! AddCityVCCell
        cell.cityNameLabel.text = cityList[indexPath.row].cityName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let sb = self.searchBar {
            sb.endEditing(true)
        }
        displayConfirmAlert(cityId: "\(cityList[indexPath.row].cityId)")
    }
    
    // MARK: - SearchBar Delegate Functions
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let sb = self.searchBar {
            sb.endEditing(true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let sb = self.searchBar {
            sb.endEditing(true)
        }
    }
    
    // MARK: - SearchBar Filter Function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.cityList.removeAll()
            DispatchQueue.main.async { [unowned self] in
                self.addCityTableView.reloadData()
            }
            let text = searchBar.text!.replacingOccurrences(of: " ", with: "_")
            NetworkController.searchByFilter(searchText: text, completion: { [unowned self] (cityData) in
                self.cityList = cityData
                self.addCityTableView.reloadData()
            })
        }
    }
    
}

// END REGION
