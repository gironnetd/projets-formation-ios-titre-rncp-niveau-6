//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by damien on 11/07/2022.
//

import UIKit
import CoreLocation

//
// MARK: - Weather ViewController
//
class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet private weak var cityNameTextField: UITextField! {
        didSet {
            cityNameTextField.text = selectedCityName
            cityNameTextField.addDoneCancelToolbar(onDone: (target: self, action: #selector(findSelectedCityWeather)))
        }
    }
    
    @IBOutlet private weak var localCityWeather: CityWeatherView!
    
    @IBOutlet private weak var selectedCityWeather: CityWeatherView!
    private var selectedCityName: String = "New York"
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private lazy var keyboardButton: UIButton = {
        let base = UIButton(type: .custom)
        base.addTarget(self, action: #selector(openKeyboard(_:)), for: .touchUpInside)
        base.setImage(UIImage(named: "keyboard"), for: .normal)
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        base.translatesAutoresizingMaskIntoConstraints = false
        return base
    }()
    
    @objc private func openKeyboard(_ sender: AnyObject) {
        cityNameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        cityNameTextField.rightViewMode = .always
        cityNameTextField.rightView = keyboardButton
        
        cityNameTextField.layer.cornerRadius = 4.0
        cityNameTextField.layer.borderWidth = 1
        cityNameTextField.layer.borderColor = UIColor.orange.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Weather"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1] as CLLocation
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        WeatherService.shared.retrieveData(
            from: WeatherRequest(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), callBack: { [self] result, error in
                
                if let error = error, error != NetworkError.NotImplemented,
                   let title = error.rawValue.title, let message = error.rawValue.message {
                    presentAlertViewController(title: title, message: message)
                }
                
                if let result = result {
                    localCityWeather.cityName.text = result.name
                    localCityWeather.weatherDescription.text = result.weather[0].weatherDescription
                    localCityWeather.temp.text = String(result.main.temp)
                    localCityWeather.minTemp.text = String(result.main.tempMin)
                    localCityWeather.maxTemp.text = String(result.main.tempMax)
                    if let icon = result.weather[0].iconImage {
                        localCityWeather.icon.image = UIImage(data: icon)
                    }
                    
                    localCityWeather.humidity.text = String(result.main.humidity)
                    localCityWeather.visibility.text = String(result.visibility)
                    activityIndicator.stopAnimating()
                    findSelectedCityWeather()
                }
                
                self.locationManager.stopUpdatingLocation()
            })
    }
    
    @objc private func findSelectedCityWeather() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        WeatherService.shared.retrieveData(
            from: WeatherRequest(cityName: cityNameTextField.text), callBack: { [self] result, error in
                if let error = error,let title = error.rawValue.title, let message = error.rawValue.message {
                    presentAlertViewController(title: title, message: message)
                }
                
                if let result = result {
                    selectedCityName = result.name
                    selectedCityWeather.cityName.text = result.name
                    selectedCityWeather.weatherDescription.text = result.weather[0].weatherDescription
                    selectedCityWeather.temp.text = String(result.main.temp)
                    selectedCityWeather.minTemp.text = String(result.main.tempMin)
                    selectedCityWeather.maxTemp.text = String(result.main.tempMax)
                    if let icon = result.weather[0].iconImage {
                        selectedCityWeather.icon.image = UIImage(data: icon)
                    }
                    selectedCityWeather.humidity.text = String(result.main.humidity)
                    selectedCityWeather.visibility.text = String(result.visibility)
                } else {
                    presentAlertViewController(title: "No City Found", message: "We did not find a city with this name")
                }
                activityIndicator.stopAnimating()
                cityNameTextField.resignFirstResponder()
            })
    }
    
    func presentAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cityNameTextField.resignFirstResponder()
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cityNameTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityNameTextField.resignFirstResponder()
          return true
       }
}
