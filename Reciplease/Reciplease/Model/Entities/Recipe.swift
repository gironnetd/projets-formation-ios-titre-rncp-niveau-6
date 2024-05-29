//
//  Recipe.swift
//  Reciplease
//
//  Created by damien on 29/07/2022.
//

import Foundation
import CoreData

// MARK: - Recipe

@objc(Recipe)
class Recipe: NSManagedObject, Codable {

    public var recipeImage: Data?
    
    enum CodingKeys: String, CodingKey {
        case label, recipeImage, url, ingredients,
         calories, totalWeight,totalTime
        case imageUrl = "image"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: CoreDataStack.shared.managedObjectContext)
        self.init(entity: entity!, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.url = try container.decode(String.self, forKey: .url)
        self.ingredients = try container.decode(Set<Ingredient>.self, forKey: .ingredients)
        self.calories = try container.decode(Double.self, forKey: .calories)
        self.totalWeight = try container.decode(Double.self, forKey: .totalWeight)
        self.totalTime = try container.decode(Int32.self, forKey: .totalTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(url, forKey: .url)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(calories, forKey: .calories)
        try container.encode(totalWeight, forKey: .totalWeight)
        try container.encode(totalTime, forKey: .totalTime)
    }
}

extension Recipe {
   @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
      return NSFetchRequest<Recipe>(entityName: "Recipe")
   }
   
    @NSManaged public var label: String
    @NSManaged public var imageUrl: String
    @NSManaged public var url: String
    @NSManaged public var ingredients: Set<Ingredient>
    @NSManaged public var calories, totalWeight: Double
    @NSManaged public var totalTime: Int32
}

