//
//  NetworkController.swift
//  OptusJob
//
//  Created by Gary Mansted on 25/6/18.
//  Copyright © 2018 Gary Mansted. All rights reserved.
//

import Foundation
import Alamofire

class NetworkController {
    static func getWeatherData(cityIds: [String], completion: @escaping (String?, [Weather]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var errorString: String? = nil
            var data: [Weather] = []
            let count = cityIds.count
            var index = 0
            // var responseCode = 0
            var weatherJSONStruct = CityJSONStruct()
            data.removeAll()
            for i in cityIds {
                Alamofire.request("\(SEARCH_BY_ID_URL)" + "\(i)" + "&units=metric&appid=" + "\(WEATHER_API_KEY)", method: .get).responseJSON { (response) in
                    switch response.result {
                    case .success(let JSON):
                       // print("*JSON*")
                       // print(JSON)
                        let response = JSON as! NSDictionary
                        // if let code = response.object(forKey: "cod") {
                        // responseCode = Int(code as! Int)
                        // }
                        if let name = response.object(forKey: "name") {
                            weatherJSONStruct.cityName = name as! String
                        }
                        if let id = response.object(forKey: "id") {
                            weatherJSONStruct.cityId = id as! Int
                        }
                        if let weather = response.object(forKey: "weather") {
                            let weatherArray = weather as! NSArray
                            for data in weatherArray {
                                let wData = data as! NSDictionary
                                if let description = wData.object(forKey: "description") {
                                    if let icon = wData.object(forKey: "icon") {
                                        if let id = wData.object(forKey: "id") {
                                            if let main = wData.object(forKey: "main") {
                                                weatherJSONStruct.weather_Description = description as! String
                                                weatherJSONStruct.weather_Icon = icon as! String
                                                weatherJSONStruct.weather_Id = id as! Int
                                                weatherJSONStruct.weather_main = main as! String
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let main = response.object(forKey: "main") {
                            let mData = main as! NSDictionary
                            if let humidity = mData.object(forKey: "humidity") {
                                if let pressure = mData.object(forKey: "pressure") {
                                    if let temp = mData.object(forKey: "temp") {
                                        if let tempMax = mData.object(forKey: "temp_max") {
                                            if let tempMin = mData.object(forKey: "temp_min") {
                                                weatherJSONStruct.mainHumidity = humidity as! Double
                                                weatherJSONStruct.mainPressure = pressure as! Double
                                                weatherJSONStruct.mainTemp = temp as! Double
                                                weatherJSONStruct.mainTempMax = tempMax as! Double
                                                weatherJSONStruct.mainTempMin = tempMin as! Double
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let sys = response.object(forKey: "sys") {
                            let sData = sys as! NSDictionary
                            if let country = sData.object(forKey: "country") {
                                if let id = sData.object(forKey: "id") {
                                    if let message = sData.object(forKey: "message") {
                                        if let sunrise = sData.object(forKey: "sunrise") {
                                            if let sunset = sData.object(forKey: "sunset") {
                                                if let type = sData.object(forKey: "type") {
                                                    weatherJSONStruct.sysCountry = country as! String
                                                    weatherJSONStruct.sysId = id as! Int
                                                    weatherJSONStruct.sysMessage = message as! Double
                                                    weatherJSONStruct.sysSunrise = sunrise as! Double
                                                    weatherJSONStruct.sysSunset = sunset as! Double
                                                    weatherJSONStruct.sysType = type as! Double
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let coord = response.object(forKey: "coord") {
                            let cData = coord as! NSDictionary
                            if let lat = cData.object(forKey: "lat") {
                                if let lon = cData.object(forKey: "lon") {
                                    weatherJSONStruct.coordLat = lat as! Double
                                    weatherJSONStruct.coordLon = lon as! Double
                                }
                            }
                        }
                        if let wind = response.object(forKey: "wind") {
                            let winData = wind as! NSDictionary
                            if let deg = winData.object(forKey: "deg") {
                                if let speed = winData.object(forKey: "speed") {
                                    weatherJSONStruct.windDeg = deg as! Double
                                    weatherJSONStruct.windSpeed = speed as! Double
                                }
                            }
                        }
                        data += [Weather(cityName: weatherJSONStruct.cityName, cityId: weatherJSONStruct.cityId, weather_Description: weatherJSONStruct.weather_Description, weather_Icon: weatherJSONStruct.weather_Icon, weather_Id: weatherJSONStruct.weather_Id, weather_main: weatherJSONStruct.weather_main, mainHumidity: weatherJSONStruct.mainHumidity, mainPressure: weatherJSONStruct.mainPressure, mainTemp: weatherJSONStruct.mainTemp, mainTempMax: weatherJSONStruct.mainTempMax, mainTempMin: weatherJSONStruct.mainTempMin, sysCountry: weatherJSONStruct.sysCountry, sysId: weatherJSONStruct.sysId, sysMessage: weatherJSONStruct.sysMessage, sysSunrise: weatherJSONStruct.sysSunrise, sysSunset: weatherJSONStruct.sysSunset, sysType: weatherJSONStruct.sysType, coordLat: weatherJSONStruct.coordLat, coordLon: weatherJSONStruct.coordLon, windDeg: weatherJSONStruct.windDeg, windSpeed: weatherJSONStruct.windSpeed)]
                    case .failure(let error):
                        print("\(error)")
                        errorString = "\(error)"
                    }
                    index += 1
                    if index == count {
                        print("FINISHED REQUESTS!!")
                        print("")
                        print(data)
                        data.sort(by: { $0.cityName < $1.cityName })
                        DispatchQueue.main.async {
                            completion(errorString, data)
                        }
                    }
                }
            }
        }
    }

    static func searchByLatAndLon(latitude: String, longtitude: String, completion: @escaping ([Weather]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var data: [Weather] = []
            var cityJSONStruct = CityJSONStruct()
            data.removeAll()
            let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude)&appid=\(WEATHER_API_KEY)")!
            Alamofire.request(url, method: .get).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                  //  print("*JSON*")
                  //  print(JSON)
                    let response = JSON as! NSDictionary
                    if let code = response.object(forKey: "cod") {
                        // responseCode = Int(code as! Int)
                    }
                    if let name = response.object(forKey: "name") {
                        cityJSONStruct.cityName = name as! String
                    }
                    if let id = response.object(forKey: "id") {
                        cityJSONStruct.cityId = id as! Int
                    }
                    if let weather = response.object(forKey: "weather") {
                        let weatherArray = weather as! NSArray
                        for data in weatherArray {
                            let wData = data as! NSDictionary
                            if let description = wData.object(forKey: "description") {
                                if let icon = wData.object(forKey: "icon") {
                                    if let id = wData.object(forKey: "id") {
                                        if let main = wData.object(forKey: "main") {
                                            cityJSONStruct.weather_Description = description as! String
                                            cityJSONStruct.weather_Icon = icon as! String
                                            cityJSONStruct.weather_Id = id as! Int
                                            cityJSONStruct.weather_main = main as! String
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let main = response.object(forKey: "main") {
                        let mData = main as! NSDictionary
                        if let humidity = mData.object(forKey: "humidity") {
                            if let pressure = mData.object(forKey: "pressure") {
                                if let temp = mData.object(forKey: "temp") {
                                    if let tempMax = mData.object(forKey: "temp_max") {
                                        if let tempMin = mData.object(forKey: "temp_min") {
                                            cityJSONStruct.mainHumidity = humidity as! Double
                                            cityJSONStruct.mainPressure = pressure as! Double
                                            cityJSONStruct.mainTemp = temp as! Double
                                            cityJSONStruct.mainTempMax = tempMax as! Double
                                            cityJSONStruct.mainTempMin = tempMin as! Double
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let sys = response.object(forKey: "sys") {
                        let sData = sys as! NSDictionary
                        if let country = sData.object(forKey: "country") {
                            if let id = sData.object(forKey: "id") {
                                if let message = sData.object(forKey: "message") {
                                    if let sunrise = sData.object(forKey: "sunrise") {
                                        if let sunset = sData.object(forKey: "sunset") {
                                            if let type = sData.object(forKey: "type") {
                                                cityJSONStruct.sysCountry = country as! String
                                                cityJSONStruct.sysId = id as! Int
                                                cityJSONStruct.sysMessage = message as! Double
                                                cityJSONStruct.sysSunrise = sunrise as! Double
                                                cityJSONStruct.sysSunset = sunset as! Double
                                                cityJSONStruct.sysType = type as! Double
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let coord = response.object(forKey: "coord") {
                        let cData = coord as! NSDictionary
                        if let lat = cData.object(forKey: "lat") {
                            if let lon = cData.object(forKey: "lon") {
                                cityJSONStruct.coordLat = lat as! Double
                                cityJSONStruct.coordLon = lon as! Double
                            }
                        }
                    }
                    if let wind = response.object(forKey: "wind") {
                        let winData = wind as! NSDictionary
                        if let deg = winData.object(forKey: "deg") {
                            if let speed = winData.object(forKey: "speed") {
                                cityJSONStruct.windDeg = deg as! Double
                                cityJSONStruct.windSpeed = speed as! Double
                            }
                        }
                    }
                    data += [Weather(cityName: cityJSONStruct.cityName, cityId: cityJSONStruct.cityId, weather_Description: cityJSONStruct.weather_Description, weather_Icon: cityJSONStruct.weather_Icon, weather_Id: cityJSONStruct.weather_Id, weather_main: cityJSONStruct.weather_main, mainHumidity: cityJSONStruct.mainHumidity, mainPressure: cityJSONStruct.mainPressure, mainTemp: cityJSONStruct.mainTemp, mainTempMax: cityJSONStruct.mainTempMax, mainTempMin: cityJSONStruct.mainTempMin, sysCountry: cityJSONStruct.sysCountry, sysId: cityJSONStruct.sysId, sysMessage: cityJSONStruct.sysMessage, sysSunrise: cityJSONStruct.sysSunrise, sysSunset: cityJSONStruct.sysSunset, sysType: cityJSONStruct.sysType, coordLat: cityJSONStruct.coordLat, coordLon: cityJSONStruct.coordLon, windDeg: cityJSONStruct.windDeg, windSpeed: cityJSONStruct.windSpeed)]
                case .failure(let error):
                    print("\(error)")
                   // self.networkError = true
                }
                print("Finished Request")
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
    
    static func searchByFilter(searchText: String, completion: @escaping ([Weather]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var data: [Weather] = []
            var cityJSONStruct = CityJSONStruct()
            data.removeAll()
            let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(searchText)&appid=\(WEATHER_API_KEY)")!
            Alamofire.request(url, method: .get).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                  //  print("*JSON*")
                  //  print(JSON)
                    let response = JSON as! NSDictionary
                    // if let code = response.object(forKey: "cod") {
                        // responseCode = Int(code as! Int)
                    // }
                    if let name = response.object(forKey: "name") {
                        cityJSONStruct.cityName = name as! String
                    }
                    if let id = response.object(forKey: "id") {
                        cityJSONStruct.cityId = id as! Int
                    }
                    if let weather = response.object(forKey: "weather") {
                        let weatherArray = weather as! NSArray
                        for data in weatherArray {
                            let wData = data as! NSDictionary
                            if let description = wData.object(forKey: "description") {
                                if let icon = wData.object(forKey: "icon") {
                                    if let id = wData.object(forKey: "id") {
                                        if let main = wData.object(forKey: "main") {
                                            cityJSONStruct.weather_Description = description as! String
                                            cityJSONStruct.weather_Icon = icon as! String
                                            cityJSONStruct.weather_Id = id as! Int
                                            cityJSONStruct.weather_main = main as! String
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let main = response.object(forKey: "main") {
                        let mData = main as! NSDictionary
                        if let humidity = mData.object(forKey: "humidity") {
                            if let pressure = mData.object(forKey: "pressure") {
                                if let temp = mData.object(forKey: "temp") {
                                    if let tempMax = mData.object(forKey: "temp_max") {
                                        if let tempMin = mData.object(forKey: "temp_min") {
                                            cityJSONStruct.mainHumidity = humidity as! Double
                                            cityJSONStruct.mainPressure = pressure as! Double
                                            cityJSONStruct.mainTemp = temp as! Double
                                            cityJSONStruct.mainTempMax = tempMax as! Double
                                            cityJSONStruct.mainTempMin = tempMin as! Double
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let sys = response.object(forKey: "sys") {
                        let sData = sys as! NSDictionary
                        if let country = sData.object(forKey: "country") {
                            if let id = sData.object(forKey: "id") {
                                if let message = sData.object(forKey: "message") {
                                    if let sunrise = sData.object(forKey: "sunrise") {
                                        if let sunset = sData.object(forKey: "sunset") {
                                            if let type = sData.object(forKey: "type") {
                                                cityJSONStruct.sysCountry = country as! String
                                                cityJSONStruct.sysId = id as! Int
                                                cityJSONStruct.sysMessage = message as! Double
                                                cityJSONStruct.sysSunrise = sunrise as! Double
                                                cityJSONStruct.sysSunset = sunset as! Double
                                                cityJSONStruct.sysType = type as! Double
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let coord = response.object(forKey: "coord") {
                        let cData = coord as! NSDictionary
                        if let lat = cData.object(forKey: "lat") {
                            if let lon = cData.object(forKey: "lon") {
                                cityJSONStruct.coordLat = lat as! Double
                                cityJSONStruct.coordLon = lon as! Double
                            }
                        }
                    }
                    if let wind = response.object(forKey: "wind") {
                        let winData = wind as! NSDictionary
                        if let deg = winData.object(forKey: "deg") {
                            if let speed = winData.object(forKey: "speed") {
                                cityJSONStruct.windDeg = deg as! Double
                                cityJSONStruct.windSpeed = speed as! Double
                            }
                        }
                    }
                    
                    if cityJSONStruct.cityName == "" {}
                    else {
                        data += [Weather(cityName: cityJSONStruct.cityName, cityId: cityJSONStruct.cityId, weather_Description: cityJSONStruct.weather_Description, weather_Icon: cityJSONStruct.weather_Icon, weather_Id: cityJSONStruct.weather_Id, weather_main: cityJSONStruct.weather_main, mainHumidity: cityJSONStruct.mainHumidity, mainPressure: cityJSONStruct.mainPressure, mainTemp: cityJSONStruct.mainTemp, mainTempMax: cityJSONStruct.mainTempMax, mainTempMin: cityJSONStruct.mainTempMin, sysCountry: cityJSONStruct.sysCountry, sysId: cityJSONStruct.sysId, sysMessage: cityJSONStruct.sysMessage, sysSunrise: cityJSONStruct.sysSunrise, sysSunset: cityJSONStruct.sysSunset, sysType: cityJSONStruct.sysType, coordLat: cityJSONStruct.coordLat, coordLon: cityJSONStruct.coordLon, windDeg: cityJSONStruct.windDeg, windSpeed: cityJSONStruct.windSpeed)]
                    }
                case .failure(let error):
                    print("\(error)")
                    // self.networkError = true
                }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }

}
