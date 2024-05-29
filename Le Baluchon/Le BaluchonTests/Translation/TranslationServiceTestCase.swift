//
//  TranslationServiceUnitTests.swift
//  Le BaluchonTests
//
//  Created by damien on 25/06/2022.
//

import XCTest
@testable import Le_Baluchon

class TranslationServiceTestCase: XCTestCase {
    
    private let fromText: String = "Je suis en train de regarder la télévision"
    private let toText: String = "I'm watching TV"
    
    func test_GivenNilDetection_WhenRetreiveData_ThenErrorIsThrown() {
        // Given Nil Detection
        let service = TranslationService(
            detectionSession: FakeURLSession(data: nil, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: FakeTranslationResponse.translation, response: nil, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { result, error in
            // Then Result Is Correct
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotFoundResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNotNilDetectionAndCorrectTranslationAndOkHttpResponse_WhenRetreiveData_ThenResultIsCorrect() {
        // Given Not Nil Detection And Correct Translation And OkHttp Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: FakeTranslationResponse.translation, response: FakeHttpResponse.OkHttpResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { result, error in
            // Then Result Is Correct
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            if let translation = result?.translation {
                XCTAssertEqual(translation, self.toText)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNotNilDetectionAndNilTranslationAndNilResponse_WhenRetreiveData_ThenErrorIsThrown() {
        // Given Not Nil Detection And Nil Translation And Nil Response
        let service = TranslationService(
            detectionSession: FakeURLSession(data: FakeTranslationResponse.detection, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.OkHttpResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { result, error in
            // Then Result Is Correct
            if result?.detection == nil {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotFoundResponse.statusCode)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNotNilLanguages_WhenRetreiveData_ThenResultIsCorrect() throws {
        // Given Not Nil Languages
        let service = TranslationService(
            detectionSession: FakeURLSession(data: nil, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: nil, response: FakeHttpResponse.OkHttpResponse, error: nil),
            languagesSession: FakeURLSession(data: FakeTranslationResponse.languages, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        let languagesResponse = try JSONDecoder().decode(TranslationResponse.self, from: FakeTranslationResponse.languages!)

        service.retrieveLanguages { result, error in
            // Then Result Is Correct
            XCTAssertNotNil(result)
            XCTAssertEqual(
                result,
                languagesResponse.data?.languages?.map { language in language.language}
            )

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilLanguages_WhenRetreiveData_ThenErrorIsThrown()  {
        // Given Nil Languages
        let service = TranslationService(
            detectionSession: FakeURLSession(data: nil, response: FakeHttpResponse.OkHttpResponse, error: nil),
            session: FakeURLSession(data: FakeTranslationResponse.translation, response: nil, error: nil),
            languagesSession: FakeURLSession(data: nil, response: FakeHttpResponse.OkHttpResponse, error: nil)
        )

        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        service.retrieveLanguages { result, error in
            // Then Result Is Correct
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotFoundResponse.statusCode)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
