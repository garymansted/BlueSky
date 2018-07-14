//
//  Structures.swift
//  OptusJob
//
//  Created by Gary Mansted on 22/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import Foundation

struct Weather {
    var cityName = String()
    var cityId = Int()
    var weather_Description = ""
    var weather_Icon = ""
    var weather_Id = 0
    var weather_main = ""
    var mainHumidity = 0.0
    var mainPressure = 0.0
    var mainTemp = 0.0
    var mainTempMax = 0.0
    var mainTempMin = 0.0
    var sysCountry = ""
    var sysId = 0
    var sysMessage = 0.0
    var sysSunrise = 0.0
    var sysSunset = 0.0
    var sysType = 0.0
    var coordLat = 0.0
    var coordLon = 0.0
    var windDeg = 0.0
    var windSpeed = 0.0
}

struct WeatherDetail {
    var cityName = String()
    var cityId = Int()
    var weather_Description = ""
    var weather_Icon = ""
    var weather_Id = 0
    var weather_main = ""
    var mainHumidity = 0.0
    var mainPressure = 0.0
    var mainTemp = 0.0
    var mainTempMax = 0.0
    var mainTempMin = 0.0
    var sysCountry = ""
    var sysId = 0
    var sysMessage = 0.0
    var sysSunrise = 0.0
    var sysSunset = 0.0
    var sysType = 0.0
    var coordLat = 0.0
    var coordLon = 0.0
    var windDeg = 0.0
    var windSpeed = 0.0
}

struct CityJSONStruct {
    var cityName = ""
    var cityId = 0
    var weather_Description = ""
    var weather_Icon = ""
    var weather_Id = 0
    var weather_main = ""
    var mainHumidity = 0.0
    var mainPressure = 0.0
    var mainTemp = 0.0
    var mainTempMax = 0.0
    var mainTempMin = 0.0
    var sysCountry = ""
    var sysId = 0
    var sysMessage = 0.0
    var sysSunrise = 0.0
    var sysSunset = 0.0
    var sysType = 0.0
    var coordLat = 0.0
    var coordLon = 0.0
    var windDeg = 0.0
    var windSpeed = 0.0
}
