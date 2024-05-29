//
//  WeatherServiceTestCase.swift
//  Le BaluchonTests
//
//  Created by damien on 13/07/2022.
//

import XCTest
import CoreLocation
@testable import Le_Baluchon

class WeatherServiceTestCase: XCTestCase {

    private let selectedCityName: String = "New York"
    private let latitude: CLLocationDegrees = 40.7143
    private let longitude: CLLocationDegrees = -74.006
    
    private var weatherResponse: WeatherResponse?
    
    override func setUpWithError() throws {
        weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: FakeWeatherResponse.correctWeather!)
        weatherResponse!.weather[0].iconImage = FakeWeatherResponse.correctIcon
    }
    
    func test_GivenCityName_WhenRetrieveData_ThenResultIsNotNull() {
        // Given City Name
        let service = WeatherService(session: FakeURLSession(data: FakeWeatherResponse.correctWeather, response: FakeHttpResponse.OkHttpResponse, error: nil), iconSession: FakeURLSession(data: FakeWeatherResponse.correctIcon, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        // When Retrieve Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        let dataRequest: WeatherRequest = WeatherRequest(cityName: selectedCityName)
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Result Is Not Null
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(result, self.weatherResponse)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenLatitudeAndLongitude_WhenRetrieveData_ThenResultIsNotNull() {
        // Given Latitude And Longitude
        let service = WeatherService(session: FakeURLSession(data: FakeWeatherResponse.correctWeather, response: FakeHttpResponse.OkHttpResponse, error: nil), iconSession: FakeURLSession(data: FakeWeatherResponse.correctIcon, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        // When Retrieve Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        let dataRequest: WeatherRequest = WeatherRequest(latitude: latitude, longitude: longitude)
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Result Is Not Null
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(result, self.weatherResponse)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenWeatherRequest_WhenRetrieveDataAndIconSessionReturnsFailedHttpResponse_ThenResultIsNotNullButNotContainIcon() {
        // Given Weather Request
        let service = WeatherService(session: FakeURLSession(data: FakeWeatherResponse.correctWeather, response: FakeHttpResponse.OkHttpResponse, error: nil), iconSession: FakeURLSession(data: nil, response: FakeHttpResponse.FailedHttpResponse, error: NetworkError.NotFound))
        
        weatherResponse!.weather[0].iconImage = nil
        
        // When Retrieve Data And Icon Session Returns Failed HttpResponse
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        let dataRequest: WeatherRequest = WeatherRequest(cityName: selectedCityName)
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Result Is Not Null But Not Contain Icon
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(result, self.weatherResponse)
            XCTAssertNil(result!.weather[0].iconImage)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenWeatherRequest_WhenRetrieveDataAndSessionReturnsFailedHttpResponse_ThenErrorIsThrown() {
        // Given Weather Request
        let service = WeatherService(session: FakeURLSession(data: nil, response: FakeHttpResponse.FailedHttpResponse, error: nil), iconSession: FakeURLSession(data: FakeWeatherResponse.correctIcon, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        // When Retrieve Data And Session Returns Failed HttpResponse
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        let dataRequest: WeatherRequest = WeatherRequest(cityName: selectedCityName)
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Error Is Thrown
            XCTAssertNotNil(error)
            XCTAssertNil(result)
        
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenWeatherRequest_WhenRetrieveDataAndSessionReturnsNilResponse_ThenErrorIsThrown() {
        // Given Weather Request
        let service = WeatherService(session: FakeURLSession(data: nil, response: nil, error: nil), iconSession: FakeURLSession(data: FakeWeatherResponse.correctIcon, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        // When Retrieve Data And Session Returns Failed HttpResponse
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        let dataRequest: WeatherRequest = WeatherRequest(cityName: selectedCityName)
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Error Is Thrown
            XCTAssertNotNil(error)
            XCTAssertNil(result)
        
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
}
