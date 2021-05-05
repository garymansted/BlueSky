//
//  UserDefaultsController.swift
//  OptusJob
//
//  Created by Gary Mansted on 26/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import Foundation

class UserDefaultService {
    
    // MARK: - Get Saved City Ids
    static func getSavedCityIds(completion: @escaping ([String]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var cityIdSavedList = [String]()
            if UserDefaults.standard.object(forKey: "citysavedlist") == nil {
                print("GETTING DEFAULT CITYIDS...")
                var defaultCities = [String]()
                defaultCities.append("2158177")
                defaultCities.append("2147714")
                defaultCities.append("2174003")
                UserDefaults.standard.set(defaultCities, forKey: "citysavedlist")
            }
            if let result:[String] = UserDefaults.standard.value(forKey: "citysavedlist") as! [String]? {
                if result.count > 0 {
                    for value in result {
                        cityIdSavedList.append(value)
                    }
                }
            }
            completion(cityIdSavedList)
        }
    }
    
    // MARK: - Save New City Entry
    static func saveNewCityIdEntryies(entries: [String]) {
        UserDefaults.standard.setValue(entries, forKey: "citysavedlist")
    }
    
}
