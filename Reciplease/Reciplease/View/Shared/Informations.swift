//
//  Information.swift
//  Reciplease
//
//  Created by damien on 28/07/2022.
//

import UIKit

@IBDesignable class Informations: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var caloriesImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    
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
        let bundle = Bundle(for: Informations.self)
        bundle.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        calories.isAccessibilityElement = true
        time.isAccessibilityElement = true
        caloriesImage.isAccessibilityElement = true
    }
    
    public func populateInformations() {
        updateCalories()
        updateTime()
    }

    private func updateCalories() {
        if let recipe = recipe {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            
            if recipe.calories >= 1000 {
                calories.text = "\(formatter.string(from: recipe.calories / 1000 as NSNumber) ?? String(0)) kcal "
            } else {
                calories.text = "\(formatter.string(from: NSNumber(value: recipe.calories)) ?? String(0)) cal "
            }
            calories.accessibilityHint = calories.text
            calories.accessibilityLabel = calories.text
            
            if recipe.calories > 1500 {
                caloriesImage.image = UIImage.init(systemName: "hand.thumbsdown.fill")
                calories.accessibilityHint = "the calorie count is over 1500 which means it is too high"
                calories.accessibilityLabel = "the calorie count is over 1500 which means it is too high"
            } else {
                caloriesImage.image = UIImage.init(systemName: "hand.thumbsup.fill")
                calories.accessibilityHint = "the calorie count is less than 1500 which means it remains correct"
                calories.accessibilityLabel = "the calorie count is less than 1500 which means it remains correct"
            }
        }
    }
    
    private func updateTime() {
        if let recipe  = recipe {
            let (hours, minutes) = ((recipe.totalTime / 60), (recipe.totalTime % 60))
            if hours != 0 || minutes != 0 {
                time.text = ""
                
                if hours != 0 {
                    time.text?.append("\(hours) h ")
                }
                
                if minutes != 0 {
                    time.text?.append("\(minutes) m")
                }
            }
            time.accessibilityHint = "the time to prepare the recipe is estimated to \(time.text!)"
            time.accessibilityLabel = "the time to prepare the recipe is estimated to \(time.text!)"
        }
    }
}
