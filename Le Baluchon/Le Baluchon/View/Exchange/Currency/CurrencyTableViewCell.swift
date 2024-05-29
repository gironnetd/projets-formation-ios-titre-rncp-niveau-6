//
//  CurrencyTableViewCell.swift
//  Le Baluchon
//
//  Created by damien on 13/07/2022.
//

import UIKit

//
// MARK: - Currency TableViewCell
//
class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    public var baseCurrency: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func commonInit() {
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 4.0
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.orange.cgColor
    }
}
