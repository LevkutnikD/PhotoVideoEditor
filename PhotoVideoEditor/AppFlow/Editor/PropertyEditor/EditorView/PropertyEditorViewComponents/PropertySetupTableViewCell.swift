//
//  TestTableViewCell.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 27.04.2022.
//

import UIKit

class PropertySetupTableViewCell: UITableViewCell {

    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var valueChangeCompletion: ((Property) -> ())?
    var property: Property?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(withProperty property: Property) {
        propertyNameLabel.text = property.title
        slider.minimumValue = property.minValue
        slider.maximumValue = property.maxValue
        slider.value = property.currentValue
        valueLabel.text = "\(property.currentValue)"
        self.property = property
    }
    
    @IBAction func changeProperty(_ sender: UISlider) {
        guard let property = self.property else { return }
        valueLabel.text = "\(sender.value)"
            property.currentValue = sender.value
            valueChangeCompletion?(property)
    }
}
