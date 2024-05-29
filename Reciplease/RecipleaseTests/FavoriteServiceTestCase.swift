//
//  RecipeController.swift
//  RecipleaseTests
//
//  Created by damien on 01/08/2022.
//

import XCTest
@testable import Reciplease

class FavoriteServiceTestCase: XCTestCase {

    private var favoriteService: FavoriteService!
    private var coreDataStack: CoreDataStack!
    private var recipes: [Recipe]!
    
    override func setUpWithError() throws {
        coreDataStack = TestingCoreDataStack()
        favoriteService = FavoriteService(managedObjectContext: coreDataStack.managedObjectContext, coreDataStack: coreDataStack)
        recipes = try JSONDecoder().decode(SearchResponse.self, from: FakeSearchResponse.search).hits.map { hit in hit.recipe }
        favoriteService.deleteAll()
    }
    
    override func tearDown() {
        favoriteService.deleteAll()
        favoriteService = nil
        coreDataStack = nil
        recipes = nil
    }
    
    func test_GIVEN_New_Recipe_WHEN_Save_Recipe_THEN_Operation_Is_Successful() throws {
        // GIVEN New Recipe
        let savedRecipe = recipes[0]
        
        // THEN Save Recipe
        favoriteService.save(recipe: savedRecipe)
        
        // THEN_Operation Is Successful
        if let storedRecipes = favoriteService.findAll() {
            XCTAssertNotNil(storedRecipes)
            XCTAssertFalse(storedRecipes.isEmpty)
            XCTAssertTrue(storedRecipes.count == 1)
            compare(recipe: storedRecipes[0], other: savedRecipe)
        }
    }
    
    func test_GIVEN_New_Recipes_WHEN_Save_Recipes_THEN_Operation_Is_Successful() throws {
        // GIVEN New Recipes
        
        // THEN Save Recipe
        recipes.forEach { savedRecipe in favoriteService.save(recipe: savedRecipe) }
        
        // THEN_Operation Is Successful
        if let storedRecipes = favoriteService.findAll() {
            XCTAssertNotNil(storedRecipes)
            XCTAssertFalse(storedRecipes.isEmpty)
            XCTAssertTrue(storedRecipes.count == recipes.count)
            for (index, storedRecipe) in storedRecipes.enumerated() {
                compare(recipe: storedRecipe, other: recipes[index])
            }
        }
    }
    
    func test_GIVEN_New_Recipes_WHEN_Delete_Recipe_THEN_Operation_Is_Successful() throws {
        // GIVEN New Recipes
        recipes.forEach { savedRecipe in favoriteService.save(recipe: savedRecipe) }
        
        // THEN Save Recipe
        favoriteService.delete(recipe: recipes[0])
        
        // THEN_Operation Is Successful
        if let storedRecipes = favoriteService.findAll() {
            XCTAssertNotNil(storedRecipes)
            XCTAssertFalse(storedRecipes.isEmpty)
            XCTAssertTrue(storedRecipes.count == recipes.count - 1)
            XCTAssertFalse(storedRecipes.contains(recipes[0]))
        }
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
