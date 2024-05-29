//
//  FavoriteService.swift
//  Reciplease
//
//  Created by damien on 01/08/2022.
//

import Foundation
import CoreData

final class FavoriteService {
    // MARK: - Properties
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack

    // MARK: - Initializers
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
      self.managedObjectContext = managedObjectContext
      self.coreDataStack = coreDataStack
    }
}

extension FavoriteService {
    @discardableResult
    public func save(recipe: Recipe) -> Recipe {
        let savedRecipe = Recipe(context: CoreDataStack.shared.managedObjectContext)
        savedRecipe.label = recipe.label
        savedRecipe.imageUrl = recipe.imageUrl
        savedRecipe.url = recipe.url
        savedRecipe.totalTime = recipe.totalTime
        savedRecipe.totalWeight = recipe.totalWeight
        savedRecipe.calories = recipe.calories
        recipe.ingredients.forEach { ingredient in
            let savedIngredient = Ingredient(context: CoreDataStack.shared.managedObjectContext)
            savedIngredient.text = ingredient.text
            savedIngredient.food = ingredient.food
            savedRecipe.ingredients.insert(savedIngredient)
        }
        saveContext()
        return savedRecipe
    }
    
    public func delete(recipe: Recipe) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "label LIKE %@", recipe.label)
        
        do {
            for recipe in try CoreDataStack.shared.managedObjectContext.fetch(request) {
                recipe.ingredients.forEach { ingredient in CoreDataStack.shared.managedObjectContext.delete(ingredient) }
                CoreDataStack.shared.managedObjectContext.delete(recipe)
            }
            saveContext()
        } catch {}
    }
    
    public func findAll() -> [Recipe]? {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        return try? CoreDataStack.shared.managedObjectContext.fetch(request)
    }
    
    public func deleteAll() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let recipes = try? CoreDataStack.shared.managedObjectContext.fetch(request)
        recipes?.forEach { recipe in
            CoreDataStack.shared.managedObjectContext.delete(recipe)
        }
        saveContext()
    }
    
    private func saveContext() {
        try? CoreDataStack.shared.managedObjectContext.save()
    }
}
