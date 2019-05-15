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
class WeatherViewController: UIViewController,CLLocationManagerDelegate, changeCityDelegate, UITableViewDataSource, UITableViewDelegate {
    
    

    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "7c609f73c5df2dff2f32e3e3cc33cd23"
    
    //task
    let FORCAST_API_URL = "http://api.openweathermap.org/data/2.5/forecast/daily"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    //step 2
    let locationManger = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let forcastWeather = ForcastWeather()

    //var forcastWeather :ForcastWeather!
    var forcastArray = [ForcastWeather]()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet var conditionImage : UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var descrOfWeather: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayMaxTemp: UILabel!
    @IBOutlet weak var todayMinTemp: UILabel!
    @IBOutlet weak var todayName: UILabel!

    
    //Variables
    var iconBool : Bool?

    //var cntArray = ["1","2","3","4","5","6","7","8","9"]
    //var dateArray = ["0","1","2","3","4","5","6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        //step 3
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManger.requestWhenInUseAuthorization()
        //Step 4
        locationManger.startUpdatingLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
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
                
                //print(weatherJSON)
                
            } else {
                print("Error \(response.result.error.debugDescription)")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    func getWeatherDataForcast(url : String, parameters: [String : String]){

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")

                
                //step 7
                let weatherJSON : JSON = JSON(response.result.value!)
                //step 8
                
                self.updateWeatherDataForcast(json: weatherJSON)
                
                //print(weatherJSON)
                
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
            let tempTodayMaxResult = json["main"]["temp_max"].double
            weatherDataModel.todayTempMax = Int(tempTodayMaxResult! - 273.15)
            weatherDataModel.todayTempMaxF = Int(tempTodayMaxResult!)
            let tempTodayMinResult = json["main"]["temp_min"].double
            weatherDataModel.todayTempMin = Int(tempTodayMinResult! - 273.15)
            weatherDataModel.todayTempMinF = Int(tempTodayMinResult!)
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.temperatureInF = Int(tempResult)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.conditionNight = json["weather"][0]["id"].intValue

            if let date = json["dt"].double {
                let rawDate = Date(timeIntervalSince1970: date)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                weatherDataModel.todayName = "\(rawDate.dayOfTheWeek())"
            }
            
            let weatherIconN = json["weather"][0]["icon"].stringValue
           // print(weatherIconN)
            weatherDataModel.descriptionWeather = json["weather"][0]["description"].stringValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.weatherIconNameNight = weatherDataModel.updateWeatherIconNight(conditionNight: weatherDataModel.conditionNight)
           
            if (weatherIconN ==  "01d") || (weatherIconN == "02d") || (weatherIconN == "03d") || (weatherIconN == "04d") || (weatherIconN == "09d") || (weatherIconN == "010d") || (weatherIconN == "011d") || (weatherIconN == "013d") || (weatherIconN == "50d") {
                iconBool = true
            } else {

                iconBool = false
            }
            //step 12
           updateUIWithWeatherData()
            
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    
    
    
    
    func updateWeatherDataForcast(json : JSON){
        
    
        clearArray()
        for item in 1...16 {
        if let tempResult = json["list"][item]["temp"]["min"].double {
            forcastWeather.tempArray.append(Int(tempResult - 273.15))
            forcastWeather.tempFArray.append(Int(tempResult))
            let tempResultMax = json["list"][item]["temp"]["max"].double
            forcastWeather.tempMaxArray.append(Int(tempResultMax! - 273.15))
            forcastWeather.tempMaxFArray.append(Int(tempResultMax!))
            
            let condition = json["list"][item]["weather"][0]["id"].intValue
            forcastWeather.conArray.append(condition)
            forcastWeather.iconArray.append(weatherDataModel.updateWeatherIcon(condition: forcastWeather.conArray[item - 1]))
            
            
            if let date = json["list"][item]["dt"].double {
                let rawDate = Date(timeIntervalSince1970: date)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                print(rawDate)
                forcastWeather.dateArray.append("\(rawDate.dayOfTheWeek())")
            }
            
            self.tableView.reloadData()
            print(tempResult)
        }else {
            print("Error")
           // clearArray()
        }
        }

}
    
    
    
    
    /***************************************************************/
    func clearArray() {
        self.forcastWeather.tempArray.removeAll()
        print(self.forcastWeather.tempArray)
        self.forcastWeather.tempFArray.removeAll()
        self.forcastWeather.tempMaxFArray.removeAll()
        self.forcastWeather.tempMaxArray.removeAll()
        self.forcastWeather.dateArray.removeAll()
        self.forcastWeather.iconArray.removeAll()
        self.forcastWeather.conArray.removeAll()
    }
        
        

    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
   
    //step 12
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        
        if `switch`.isOn == true {
            temperatureLabel.text = "\(weatherDataModel.temperature)°"
            todayMaxTemp.text = String(weatherDataModel.todayTempMax)
            todayMinTemp.text = String(weatherDataModel.todayTempMin)
        } else {
            temperatureLabel.text = "\(weatherDataModel.temperatureInF)°"
            todayMaxTemp.text = String(weatherDataModel.todayTempMaxF)
            todayMinTemp.text = String(weatherDataModel.todayTempMinF)

        }
        
        
        if iconBool == true {
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        }
        else {
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconNameNight)
        }
        
        todayName.text = weatherDataModel.todayName
        descrOfWeather.text = weatherDataModel.descriptionWeather
        
        //conditionImage.image = UIImage(named: weatherDataModel.conditionPic)
        
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
            
            let paramsForcast : [String : String] = ["lat" : latitude, "lon" : longitude, "cnt" : "16", "appid" : APP_ID]
            
            // step 6
            getWeatherData(url: WEATHER_URL, parameters: params)
            
            getWeatherDataForcast(url: FORCAST_API_URL, parameters: paramsForcast)
            
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
        let paramsForcast : [String : String] = ["q" : city,"cnt" : "16", "appid" : APP_ID]
        
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        getWeatherDataForcast(url: FORCAST_API_URL, parameters: paramsForcast)

    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
    
    
    
    
    //MARK: - Switch Key
    /***************************************************************/
    @IBAction func switchCilcked(_ sender: UISwitch) {
        
        if (sender.isOn == true) {
            
            degreeLabel.text = "C°"
            self.tableView.reloadData()
            updateUIWithWeatherData()

        } else {
            degreeLabel .text = "F°"
            self.tableView.reloadData()
            updateUIWithWeatherData()
        }
        
    }
    
    
    
    
    
    
    
    //MARK: - Tableview
    /***************************************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forcastWeather.tempArray.count - 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ForcastCellTableViewCell

        if `switch`.isOn == true {
            cell.forcastTemp.text = String(forcastWeather.tempArray[indexPath.row])
            cell.forcastTempMax.text = String(forcastWeather.tempMaxArray[indexPath.row])
        } else {
            cell.forcastTempMax.text = String(forcastWeather.tempMaxFArray[indexPath.row])
            cell.forcastTemp.text = String(forcastWeather.tempFArray[indexPath.row])
            
        }

        cell.imageIcon.image = UIImage(named: forcastWeather.iconArray[indexPath.row])
        cell.forcastDay.text = forcastWeather.dateArray[indexPath.row]


        return cell
    }
    
    
    
}


