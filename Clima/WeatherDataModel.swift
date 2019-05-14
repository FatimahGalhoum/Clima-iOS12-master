//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Angela Yu on 24/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class WeatherDataModel {

    //Declare your model variables here
    //step 9
    var temperature : Int = 0
    var temperatureInF : Int = 0

    var condition : Int = 0
    var city : String = ""
    var conditionPic : String = ""
    var weatherIconName : String = ""
    
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> String {
        

        
    switch (condition) {
    
        case 0...300 :
            conditionPic = "tstorm1-1"
            return "tstorm1"
        
        case 301...500 :
            conditionPic = "light-rain-1"
            return "light_rain"
        
        case 501...600 :
            conditionPic = "shower1"
            return "shower3"
        
        case 601...700 :
            conditionPic = "snow1"
            return "snow4"
        
        case 701...771 :
            conditionPic = "fog1"
            return "fog"
        
        case 772...799 :
            conditionPic = "tstorm1-2"
            return "tstorm3"
        
        case 800 :
            conditionPic = "sun1"
            return "sunny"
        
        case 801...804 :
            conditionPic = "cloud1"
            return "cloudy2"
        
        case 900...903, 905...1000  :
            conditionPic = "tstorm1-1"
            return "tstorm3"
        
        case 903 :
            conditionPic = "snow2"
            return "snow5"
        
        case 904 :
            conditionPic = "sun2"
            return "sunny"
        
        default :
            return "dunno"
        }
    }
}
