//
//  RecipeDetailHeaderView.swift
//  Reciplease
//
//  Created by damien on 25/07/2022.
//

import UIKit

@IBDesignable class RecipeDetailHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var informations: Informations!
    
    public var recipe: Recipe?
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: RecipeDetailHeaderView.self)
        bundle.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        recipeTitle.isAccessibilityElement = true
        recipeImage.isAccessibilityElement = true
    }
    
    public func populateHeaderView() {
        updateTitle()
        if let recipe = recipe, let recipeImage = recipe.recipeImage {
            self.recipeImage.image = UIImage(data: recipeImage)
            informations.recipe = recipe
            informations.populateInformations()
        }
    }
    
    private func updateTitle() {
        if let recipe = recipe {
            recipeTitle.text = recipe.label.replacingOccurrences(of: "&amp;amp;", with: "&")
            recipeTitle.accessibilityHint = recipeTitle.text
            recipeTitle.accessibilityLabel = recipeTitle.text
        }
    }
}
