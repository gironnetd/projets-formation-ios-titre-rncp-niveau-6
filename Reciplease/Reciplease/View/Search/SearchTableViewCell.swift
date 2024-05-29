//
//  SearchTableViewCell.swift
//  Reciplease
//
//  Created by damien on 20/07/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredient: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredient.isAccessibilityElement = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
