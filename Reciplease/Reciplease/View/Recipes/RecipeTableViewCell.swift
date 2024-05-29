//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by damien on 21/07/2022.
//

import UIKit

@IBDesignable class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var informations: Informations!
    
    public var recipe: Recipe?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.isAccessibilityElement = true
        ingredients.isAccessibilityElement = true
        recipeImage.isAccessibilityElement = true
    }
        
    public func populateTableViewCell() {
        updateTitleAndIngredients()
        if let recipe = recipe {
            informations.recipe = recipe
            informations.populateInformations()
        }
    }
    
    private func updateTitleAndIngredients() {
        if let recipe = recipe {
            title.text = recipe.label.replacingOccurrences(of: "&amp;amp;", with: "&")
            title.accessibilityHint = title.text
            title.accessibilityLabel = title.text
            
            ingredients.text = recipe.ingredients.map { ingredient in ingredient.food }.joined(separator: ", ")
            ingredients.accessibilityHint = ingredients.text
            ingredients.accessibilityLabel = ingredients.text
        }
    }
}
