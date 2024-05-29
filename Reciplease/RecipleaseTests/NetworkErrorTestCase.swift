//
//  NetworkErrorTestCase.swift
//  RecipleaseTests
//
//  Created by damien on 28/07/2022.
//

//
//  ApiServiceNetworkErrorTestCase.swift
//  Le BaluchonTests
//
//  Created by damien on 11/07/2022.
//

import XCTest
import Alamofire
import Mocker
@testable import Reciplease

class NetworkErrorTestCase: XCTestCase {

    private lazy var service: SearchService = {
        SearchService(sessionManager: sessionManager)
    }()
    
    private lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        return Alamofire.Session(configuration: configuration)
    }()
    
    private lazy var apiEndpoint: URL = {
        URL(string: "https://api.edamam.com/api/recipes/v2?\(service.apiKeyValuesForTesting().joined(separator: "&"))&q=cheese%2Ctomatoes&type=public")!
    }()
    
    func test_GIVEN_Nil_Result_And_NotFoundResponse_WHEN_Retrieve_Data_THEN_NotFoundResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And Not Found Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.NotFoundResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data And Return Error
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // NotFoundResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotFoundResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_FailedResponse_WHEN_Retrieve_Data_THEN_FailedResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And Failed Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.FailedHttpResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // FailedResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.FailedHttpResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_UnauthorizedResponse_Response_WHEN_Retrieve_Data_THEN_UnauthorizedResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And Unauthorized Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.UnauthorizedResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // UnauthorizedResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.UnauthorizedResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }

    func test_GIVEN_Nil_Result_And_ForbiddenResponse_Response_WHEN_Retrieve_Data_THEN_ForbiddenResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And Forbidden Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.ForbiddenResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // ForbiddenResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.ForbiddenResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_BadRequestResponse_Response_WHEN_Retrieve_Data_THEN_BadRequestResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And BadRequest Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.BadRequestResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // BadRequestResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.BadRequestResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_TooManyRequestsResponse_Response_WHEN_Retrieve_Data_THEN_TooManyRequestsResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And TooManyRequests Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.TooManyRequestsResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // TooManyRequestsResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.TooManyRequestsResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_InternalServerErrorResponse_Response_WHEN_Retrieve_Data_THEN_InternalServerErrorResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And InternalServerError Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.InternalServerErrorResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // InternalServerErrorResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.InternalServerErrorResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_BadGatewayResponse_Response_WHEN_Retrieve_Data_THEN_BadGatewayResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And BadGateway Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.BadGatewayResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // BadGatewayResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.BadGatewayResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_ServiceUnavailableResponse_Response_WHEN_Retrieve_Data_THEN_ServiceUnavailableResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And ServiceUnavailable Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.ServiceUnavailableResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // ServiceUnavailableResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.ServiceUnavailableResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_GatewayTimedOutResponse_Response_WHEN_Retrieve_Data_THEN_GatewayTimedOutResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And GatewayTimedOut Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.GatewayTimedOutResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // GatewayTimedOutResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.GatewayTimedOutResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Nil_Result_And_NotImplementedResponse_Response_WHEN_Retrieve_Data_THEN_NotImplementedResponse_Error_Is_Thrown() throws {
        // GIVEN Nil Result And NotImplemented Response
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.NotImplementedResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // NotImplementedResponse Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotImplementedResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
}
