//
//  CityWeatherView.swift
//  Le Baluchon
//
//  Created by damien on 12/07/2022.
//

import UIKit

//
// MARK: - City Weather View
//
@IBDesignable class CityWeatherView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var visibility: UILabel!
    
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
        let bundle = Bundle(for: CityWeatherView.self)
        bundle.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
