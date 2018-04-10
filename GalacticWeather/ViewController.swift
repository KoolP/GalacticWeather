//
//  ViewController.swift
//  GalacticWeather
//
//  Created by Patrik Rikama Hinnenberg on 2018-04-07.
//  Copyright © 2018 Koolsport. All rights reserved.
//

import UIKit
//let weather : [WeatherArr]
//var openWeatherResponse = OpenWeatherResponse (main: [MainData])

//struct WeatherCondition {
//    let cityName: String?
//    let weather: String
//    let temp: Double
//}

//main response
struct OpenWeatherResponse : Codable {
    let main: [String: Double]
//    let coord: [String: String]
    //let weather: [WeatherArr]
    //let main: [MainData]
}

struct MainDict : Codable {
    let temp: Double?
    let temp_min: Double?
    let temp_max: Double?}

struct CoordDict:Decodable {
    let lon: Double?
    let lat: Double?}

struct WeatherArr:Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?}

struct WindDict:Decodable {
    let speed:Double?
    let deg:Double?}


class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spacePicBarButton: UIBarButtonItem!
    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var bottomBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbarStyle()
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        spacePicBarButton.isEnabled = false
        spacePicBarButton.isEnabled = true
    }
    
    //API search for temp, tower of doom
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button/enter pressed")
        
        //Double if let in begginning, %20% for space in search
        
        if let safeString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(safeString)&format=json&pretty=1&appid=a46f63c4899f9a64dc67f7114b104f2b") {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler:
            { (data : Data?, response : URLResponse?, error: Error?) in
                if let actualError = error {
                    print(actualError)
                } else {
                    if let actualData = data {
                        
                        
                        //"main" Codable, egna structer som json ser ut
                        let decoder = JSONDecoder()
                        
                        do {
                            let openWeatherResponse = try decoder.decode(OpenWeatherResponse.self, from: actualData)
                            print(openWeatherResponse)
                            
//                            var d
//                            for(temp, actualTemp) in openWeatherResponse {
//                                print(\(actualTemp))
//                            }
                            //This would have been nice, but not working:
                            //let index = openWeatherResponse.index(value(forKey: "temp"))
                            
                            
                        } catch let e {
                            print("Error parsing json: \(e)")
                        }
                        
                        
                    } else {
                        print("Data was nil")
                    }
                }
            })
            
            task.resume()
            
        } else {
            print("Bad URL")
        }
        
        
    }
    
    
    func navbarStyle() {
        //NavBar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
        spacePicBarButton.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Futura", size: 14)!], for: UIControlState.normal)
        spacePicBarButton.title = "🚀"
        searchTitle.text = "🌍"
        
        searchTitle.font = UIFont(name:"American Typewriter", size: 14)
        temp.font = UIFont(name:"American Typewriter", size: 14)
        city.font = UIFont(name:"American Typewriter", size: 14)
        condition.font = UIFont(name:"American Typewriter", size: 10)
        bottomBackground.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        bottomBackground.layer.cornerRadius = 12
        
        //SearchBar
        let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search city", attributes: attributeDict)
        }
        let glassIconView = searchTextField?.leftView as? UIImageView
        
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor.lightGray
    }


}


//Test this
//https://stackoverflow.com/questions/46636533/json-parsing-in-swift-4-with-complex-nested-data
//https://stackoverflow.com/questions/49601788/creating-a-list-from-nested-json-using-decodable-in-swift-4



////API search for temp in Celsius via searchBar and from Open WeatherAPI
////This is the tower of doom code without decodable from Swift 4
//func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    print("Search button/enter pressed")
//
//    //Double if let in begginning, %20% for space in search
//
//    if let safeString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
//        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(safeString)&format=json&pretty=1&appid=a46f63c4899f9a64dc67f7114b104f2b") {
//
//        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: request, completionHandler:
//        { (data : Data?, response : URLResponse?, error: Error?) in
//            if let actualError = error {
//                print(actualError)
//            } else {
//                if let actualData = data {
//
//                    let options = JSONSerialization.ReadingOptions()
//                    do {
//                        let parsed = try JSONSerialization.jsonObject(with: actualData, options: options)
//                        //print(parsed)
//
//                        //parsing form server answer, error handling first
//                        if let dict = parsed as? [String: AnyObject] {
//                            if let mainWeather = dict["main"] {
//
//
//                                if let tempData = mainWeather["temp"] {
//                                    if let actualTemp = tempData as? Double {
//                                        //print(actualData)
//                                        //print(tempData!)
//                                        DispatchQueue.main.async {
//                                            self.temp.text = String(format: "%.1f° C", actualTemp - 273.15)
//                                        }
//                                        //self.temp.text = String(format: "%.1f°", tempData)
//                                    } else {
//                                        print("Temp was not a Double")
//                                    }
//                                } else {
//                                    print("First topic was not a double")
//                                }
//
//
//                                //print(mainWeather)
//                            } else {
//                                print("Cant find main key value")
//                            }
//                        } else {
//                            print("Can't create dict.")
//                        }
//
//                    } catch {
//                        print("Failed to parse json")
//                    }
//
//                } else {
//                    print("Data was nil")
//                }
//            }
//        })
//
//        task.resume()
//
//    } else {
//        print("Bad URL")
//    }
//
//
//}

