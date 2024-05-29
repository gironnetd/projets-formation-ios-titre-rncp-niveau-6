//
//  ApiServiceNetworkErrorTestCase.swift
//  Le BaluchonTests
//
//  Created by damien on 11/07/2022.
//

import XCTest
@testable import Le_Baluchon

class NetworkErrorTestCase: XCTestCase {

    func test_GivenNilTranslationAndFailedHttpResponse_WhenRetreiveData_ThenFailedHttpErrorIsThrown() {
        // Given Nil Translation And Failed HttpResponse
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.FailedHttpResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.FailedHttpResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndNotFoundResponse_WhenRetreiveData_ThenNotFoundErrorIsThrown() {
        // Given Nil Translation And NotFound Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.NotFoundResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
    
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotFoundResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndUnauthorizedResponse_WhenRetreiveData_ThenUnauthorizedErrorIsThrown() {
        // Given Nil Translation And Unauthorized Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.UnauthorizedResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.UnauthorizedResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndForbiddenResponse_WhenRetreiveData_ThenForbiddenErrorIsThrown() {
        // Given Nil Translation And Forbidden Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.ForbiddenResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.ForbiddenResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndBadRequestResponse_WhenRetreiveData_ThenBadRequestErrorIsThrown() {
        // Given Nil Translation And BadRequest Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.BadRequestResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.BadRequestResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_GivenNilTranslationAndTooManyRequestsResponse_WhenRetreiveData_ThenTooManyRequestsErrorIsThrown() {
        // Given Nil Translation And TooManyRequests Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.TooManyRequestsResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.TooManyRequestsResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndInternalServerErrorResponse_WhenRetreiveData_ThenInternalServerErrorIsThrown() {
        // Given Nil Translation And InternalServerError Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.InternalServerErrorResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.InternalServerErrorResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndBadGatewayResponse_WhenRetreiveData_ThenBadGatewayErrorIsThrown() {
        // Given Nil Translation And BadGateway Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.BadGatewayResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.BadGatewayResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndServiceUnavailableResponse_WhenRetreiveData_ThenServiceUnavailableErrorIsThrown() {
        // Given Nil Translation And ServiceUnavailable Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.ServiceUnavailableResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.ServiceUnavailableResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndGatewayTimedOutResponse_WhenRetreiveData_ThenGatewayTimedOutErrorIsThrown() {
        // Given Nil Translation And GatewayTimedOut Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.GatewayTimedOutResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.GatewayTimedOutResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndNotImplementedResponse_WhenRetreiveData_ThenNotImplementedErrorIsThrown() {
        // Given Nil Translation And NotImplemented Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.NotImplementedResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        service.retrieveData(from: "") { result, error in
            // Then Failed Http Error Is Thrown
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotImplementedResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
