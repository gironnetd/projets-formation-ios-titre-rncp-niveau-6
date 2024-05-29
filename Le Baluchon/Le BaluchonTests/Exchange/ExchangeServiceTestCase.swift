//
//  FakeExchangeServiceTestCase.swift
//  Le BaluchonTests
//
//  Created by damien on 11/07/2022.
//

import XCTest
@testable import Le_Baluchon

class ExchangeServiceTestCase: XCTestCase {
    
    private let baseCurrency = "EUR"
    private var symbolCurrencies = ["USD", "GBP", "JPY"]
    
    override func setUp() {
        symbolCurrencies = ["USD", "GBP", "JPY"]
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    override func tearDown() {
        UserDefaults.standard.set(dateFormatter.string(from: Date()), forKey: Constants.LAST_DATE_UPDATED)
    }
    
    func test_Given_LatestEndPoint_And_DateNotChanged_And_CorrectExchange_WithMultipleSymbols_And_OkHttpResponse_WhenRetrieveData_ThenResultIsCorrect() {
        // Given Latest EndPoint And Date Not Changed And CorrectExchange With Multiple Symbols And OkHttpResponse
        UserDefaults.standard.setValue(nil, forKey: Constants.LAST_DATE_UPDATED)
        
        let service = ExchangeService(session: FakeURLSession(data: FakeExchangeResponse.correctRates, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        symbolCurrencies = ["USD", "GBP"]
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.latest, baseCurrency: baseCurrency, symbolCurrencies: symbolCurrencies)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { [self] result, error in
            // Then Result Is Correct
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertTrue(symbolCurrencies.allSatisfy { key in (result?.keys.contains(key)) ?? false })
            XCTAssertTrue(result!.keys.allSatisfy { key in symbolCurrencies.contains(key)})
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_LatestEndPoint_And_DateNotChanged_And_CorrectExchange_WithOneSymbol_And_OkHttpResponse_WhenRetrieveData_ThenResultIsCorrect() {
        // Given Latest EndPoint And Date Not Changed And CorrectExchange With One Symbol And OkHttpResponse
        let service = ExchangeService(session: FakeURLSession(data: FakeExchangeResponse.correctRates, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        symbolCurrencies = ["USD"]
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.latest, baseCurrency: baseCurrency, symbolCurrencies: symbolCurrencies)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { [self] result, error in
            // Then Result Is Correct
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertTrue(symbolCurrencies.allSatisfy { key in (result?.keys.contains(key)) ?? false })
            XCTAssertTrue(result!.keys.allSatisfy { key in symbolCurrencies.contains(key)})
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_SymbolsEndPoint_And_DateNotChanged_And_CorrectExchange_And_OkHttpResponse_WhenRetrieveData_ThenResultIsCorrect() {
        // Given Symbols EndPoint And Date Not Changed And CorrectExchange And OkHttpResponse
        let service = ExchangeService(session: FakeURLSession(data: FakeExchangeResponse.correctSymbols, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.symbols)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Result Is Correct
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertFalse(result!.isEmpty)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_LatestEndPoint_And_DateHasBeenChanged_And_OkHttpResponse_WhenRetrieveData_ThenResultIsCorrect() {
        // Given Latest EndPoint And Date Has Been Changed And CorrectExchange And OkHttpResponse
        UserDefaults.standard.setValue("Monday, July 9, 2022", forKey: Constants.LAST_DATE_UPDATED)
        
        let service = ExchangeService(session: FakeURLSession(data: FakeExchangeResponse.correctRates, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        symbolCurrencies = ["USD"]
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.latest, baseCurrency: baseCurrency, symbolCurrencies: symbolCurrencies)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { [self] result, error in
            // Then Result Is Correct
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertTrue(symbolCurrencies.allSatisfy { key in (result?.keys.contains(key)) ?? false })
            XCTAssertTrue(result!.keys.allSatisfy { key in symbolCurrencies.contains(key)})
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_LatestEndPoint_And_DateHasBeenChanged_And_OkHttpResponse_WhenRetrieveData_ThenUserDefaultHasBeenUpdated() {
        // Given Latest EndPoint And Date Has Been Changed And CorrectExchange And OkHttpResponse
        UserDefaults.standard.setValue(nil, forKey: Constants.RATES)
        
        let service = ExchangeService(session: FakeURLSession(data: FakeExchangeResponse.correctRates, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        symbolCurrencies = ["USD"]
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.latest, baseCurrency: baseCurrency, symbolCurrencies: symbolCurrencies)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { [self] result, error in
            // Then UserDefault Has Been Updated
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            
            let cacheRates = UserDefaults.standard.dictionary(forKey: Constants.RATES)
            
            let actualCachedRates = cacheRates![baseCurrency] as! [String : Double]
            
            XCTAssertEqual(
                actualCachedRates.filter { key, _ in key == symbolCurrencies[0] },
                result as! [String : Double])
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_SymbolsEndPoint_And_DateHasBeenChanged_And_OkHttpResponse_WhenRetrieveData_ThenUserDefaultHasBeenUpdated() {
        // Given Symbols EndPoint And Date Has Been Changed And CorrectExchange And OkHttpResponse
        UserDefaults.standard.setValue(nil, forKey: Constants.RATES)
        
        let service = ExchangeService(session: FakeURLSession(data: FakeExchangeResponse.correctSymbols, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        symbolCurrencies = ["USD"]
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.symbols)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then UserDefault Has Been Updated
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            
            let cacheSymbols = UserDefaults.standard.dictionary(forKey: Constants.SYMBOLS)
            
            let actualCachedSymbols = cacheSymbols as! [String : String]
            
            XCTAssertEqual(
                actualCachedSymbols,
                result as! [String : String])
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_LatestEndPoint_And_DateHasBeenChanged_AndFailedHttpResponse_WhenRetrieveData_ThenErrorIsThrown() {
        // Given Latest EndPoint And Date Has Been Changed And CorrectExchange And FailedHttpResponse
        UserDefaults.standard.setValue("Monday, July 10, 2022", forKey: Constants.LAST_DATE_UPDATED)
        
        let service = ExchangeService(session: FakeURLSession(data: nil, response: FakeHttpResponse.FailedHttpResponse, error: nil))
        
        symbolCurrencies = ["USD"]
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.latest, baseCurrency: baseCurrency, symbolCurrencies: symbolCurrencies)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Error Is Thrown
            XCTAssertNotNil(error)
            XCTAssertNil(result)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_SymbolEndPoint_And_DateHasBeenChanged_AndOkHttpResponse_WhenRetrieveData_ThenResultIsCorrect() {
        // Given Symbol EndPoint And Date Has Been Changed And CorrectExchange And OkHttpResponse
        UserDefaults.standard.setValue("Monday, July 9, 2022", forKey: Constants.LAST_DATE_UPDATED)
        
        let service = ExchangeService(session: FakeURLSession(data: FakeExchangeResponse.correctSymbols, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.symbols)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Result Is Correct
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertFalse(result!.isEmpty)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Given_SymbolEndPoint_And_DateHasBeenChanged_AndFailedHttpResponse_WhenRetrieveData_ThenErrorIsThrown() {
        // Given Symbol EndPoint And Date Has Been Changed And CorrectExchange And FailedHttpResponse
        UserDefaults.standard.setValue("Monday, July 10, 2022", forKey: Constants.LAST_DATE_UPDATED)
        
        let service = ExchangeService(session: FakeURLSession(data: nil, response: FakeHttpResponse.FailedHttpResponse, error: nil))
        
        let dataRequest = ExchangeRequest(endPoint: ExchangeEndPoint.symbols)
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: dataRequest, callBack: { result, error in
            // Then Error Is Thrown
            XCTAssertNotNil(error)
            XCTAssertNil(result)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
}
