//
//  Ingredient.swift
//  Reciplease
//
//  Created by damien on 29/07/2022.
//

import Foundation
import CoreData

// MARK: - Ingredient
@objc(Ingredient)
class Ingredient: NSManagedObject, Codable {

    enum CodingKeys: CodingKey {
        case text, food
    }
    
    required convenience init(from decoder: Decoder) throws {
        let entity = NSEntityDescription.entity(forEntityName: "Ingredient", in: CoreDataStack.shared.managedObjectContext)
        self.init(entity: entity!, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.food = try container.decode(String.self, forKey: .food)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(food, forKey: .food)
    }
}

extension Ingredient {
    @NSManaged public var text: String
    @NSManaged public var food: String
}
