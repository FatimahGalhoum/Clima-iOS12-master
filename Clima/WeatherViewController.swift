//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
//step 1
import CoreLocation
//step 6
import Alamofire
import SwiftyJSON

//step 14 add city delegate
class WeatherViewController: UIViewController,CLLocationManagerDelegate, changeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "31617b8c8bb41ce9cca2abe8a65d581c"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    //step 2
    let locationManger = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet var conditionImage : UIImageView!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        //step 3
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManger.requestWhenInUseAuthorization()
        //Step 4
        locationManger.startUpdatingLocation()
        

    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    //step 6
    func getWeatherData(url : String, parameters: [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                //step 7
                let weatherJSON : JSON = JSON(response.result.value!)
                //step 8
                self.updateWeatherData(json: weatherJSON)
                
                print(weatherJSON)
                
            } else {
                print("Error \(response.result.error.debugDescription)")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    
    

    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    //step 8
    func updateWeatherData(json : JSON){
        
        if let tempResult = json["main"]["temp"].double {
            
        //step 11
            
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.temperatureInF = Int(tempResult)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
          
            //step 12
           updateUIWithWeatherData()
            
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
   
    //step 12
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        
        if `switch`.isOn == true {
            temperatureLabel.text = "\(weatherDataModel.temperature)°"
        } else {
            temperatureLabel.text = "\(weatherDataModel.temperatureInF)"
        }
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        conditionImage.image = UIImage(named: weatherDataModel.conditionPic)
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    //step 5
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            //to stop getting multiple lon and lat
            locationManger.delegate = nil
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            // step 6
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    //step 5
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    //step 15
    func userEnteredANewCityName(city: String) {
        
        //step17
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
    
    @IBAction func switchCilcked(_ sender: UISwitch) {
        
        if (sender.isOn == true) {
            
            degreeLabel.text = "C°"
            updateUIWithWeatherData()

        } else {
            degreeLabel .text = "F"
            updateUIWithWeatherData()
        }
        
    }
    
    
    
}


