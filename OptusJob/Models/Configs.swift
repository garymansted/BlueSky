//
//  Configs.swift
//  OptusJob
//
//  Created by Gary Mansted on 22/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import Foundation

let MAIN_APP_COLOR = UIColor(red: 118/255, green: 214/255, blue: 1, alpha: 1)
let NAV_BAR_BUTTON_COLOR = UIColor.darkGray
let NAV_BAR_TITLE_COLOR = UIColor.white
let NAV_BAR_ATTRIBUTES = [NSAttributedString.Key.foregroundColor : UIColor.white,
                          NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Light", size: 26)!]
// Enter API keys below:
let WEATHER_API_KEY = SECRET_WEATHER_API_KEY
let GOOGLE_MAPS_API_KEY = SECRET_GOOGLE_MAPS_API_KEY
let SEARCH_BY_ID_URL = URL(string: "http://api.openweathermap.org/data/2.5/weather?id=")!
let REFRESH_TIME = 60.0
let ACTIVITY_INDICATOR_SPINNER_COLOR = UIColor.white




