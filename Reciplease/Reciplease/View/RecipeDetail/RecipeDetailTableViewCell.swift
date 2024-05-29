//
//  RecipeDetaillTableViewCell.swift
//  Reciplease
//
//  Created by damien on 25/07/2022.
//

import UIKit

class RecipeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientLine.isAccessibilityElement = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
