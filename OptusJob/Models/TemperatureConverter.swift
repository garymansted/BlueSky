//
//  TemperatureConverter.swift
//  OptusJob
//
//  Created by Gary Mansted on 26/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import Foundation

class TemperatureConverter {
    
    static func tempConverter(temp: Double) -> String {
        let t = temp.rounded()
        let tempAsInt = Int(t)
        return "\(tempAsInt)"
    }

}
