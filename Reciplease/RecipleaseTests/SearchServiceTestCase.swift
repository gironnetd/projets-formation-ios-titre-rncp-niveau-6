//
//  SearchServiceTestCase.swift
//  RecipleaseTests
//
//  Created by damien on 27/07/2022.
//

import XCTest
import Mocker
import Alamofire
@testable import Reciplease

class SearchServiceTestCase: XCTestCase {
    
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
    
    func test_GIVEN_Not_Nil_Request_WHEN_Retrieve_Data_THEN_Result_Is_Correct() throws {
        // GIVEN Not Nil Request
        let expectedResponse = try! JSONDecoder().decode(SearchResponse.self, from: FakeSearchResponse.search)
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = try! JSONEncoder().encode(expectedResponse)
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.OkHttpResponse.statusCode, data: [.get: mockedData])
        mock.register()
        
        // THEN Retrieve Data
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // THEN_Result_Is_Correct
                XCTAssertNil(error)
                for(index, recipe) in recipes!.enumerated() {
                    self.compare(recipe: recipe, other: expectedResponse.hits[index].recipe)
                    //XCTAssertTrue(recipe == expectedResponse.hits[index].recipe)
                }
            }
        })
    
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    func test_GIVEN_Not_Nil_Request_WHEN_Retrieve_Data_And_Return_Error_THEN_Error_Is_Thrown() throws {
        // GIVEN Not Nil Request
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: FakeHttpResponse.NotFoundResponse.statusCode, data: [.get: Data()])
        mock.register()
        
        // THEN Retrieve Data And Return Error
        service.retrieveRecipes(ingredients: ["cheese", "tomatoes"], callBack: { recipes, error in
            defer { requestExpectation.fulfill() }
            do {
                // Error Is Thrown
                XCTAssertNil(recipes)
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.rawValue.code, FakeHttpResponse.NotFoundResponse.statusCode)
            }
        })
        wait(for: [requestExpectation], timeout: 20.0)
    }
    
    private func compare(recipe: Recipe, other: Recipe) {
        XCTAssertTrue(recipe.label == other.label)
        XCTAssertTrue(recipe.calories == other.calories)
        XCTAssertTrue(recipe.imageUrl == other.imageUrl)
        XCTAssertTrue(recipe.url == other.url)
        XCTAssertTrue(recipe.calories == other.calories)
        XCTAssertTrue(recipe.totalWeight == other.totalWeight)
        XCTAssertTrue(recipe.totalTime == other.totalTime)
        recipe.ingredients.forEach { ingredient in other.ingredients.contains(ingredient)}
    }
}
