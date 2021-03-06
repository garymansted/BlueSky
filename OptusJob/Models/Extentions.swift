//
//  Extentions.swift
//  OptusJob
//
//  Created by Gary Mansted on 23/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import Foundation

// MARK - Double Extention
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: - UIView Extentions
extension UIView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

// MARK: - ViewController Extentions
extension UIViewController {
    // MARK: - Display Restricted Location Alert -
    func displayRestrictedLocationAlert() {
        let alertController = UIAlertController(title: "Location Restricted", message: "In order to use this function you must change 'Location' from 'Never' to 'While Using the App' by selecting OptusJob in the device's Settings", preferredStyle: UIAlertController.Style.alert)
        let goto_settings_action = UIAlertAction(title: "Go to Settings now", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (true) in
                print("")
            })
        }
        let not_now_action = UIAlertAction(title: "Not now", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in }
        alertController.addAction(goto_settings_action)
        alertController.addAction(not_now_action)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Display Network Error Alert
    func displayNetworkErrorMessage() {
        let alertController = UIAlertController(title: "No Internet", message: "Please check your network settings and try again", preferredStyle: UIAlertController.Style.alert)
        let button1_action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in }
        alertController.addAction(button1_action)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Display City Error Alert
    func displayCityErrorMessage() {
        let alertController = UIAlertController(title: "Select Again", message: "Unable to save as the location you have selected does not have a nearby city.\nPlease select again", preferredStyle: UIAlertController.Style.alert)
        let button1_action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in }
        alertController.addAction(button1_action)
        self.present(alertController, animated: true, completion: nil)
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension UIViewController {
func setupNavBarLargeTitle() {
    if #available(iOS 11.0, *) {
        navigationController?.navigationBar.prefersLargeTitles = true
    } else {
        // Fallback on earlier versions
    }
    if #available(iOS 11.0, *) {
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    } else {
        // Fallback on earlier versions
    }
    navigationController?.navigationBar.barTintColor = .black
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    if #available(iOS 11.0, *) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    } else {
        // Fallback on earlier versions
    }
}

}
