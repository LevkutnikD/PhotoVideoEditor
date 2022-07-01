//
//  PropertyComponents.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 27.04.2022.
//

import Foundation

class Property {
    let title: String
    let filter: String
    let propertyKey: String
    let minValue: Float
    let maxValue: Float
    let defaultValue: Float
    var currentValue: Float
    
    init(title: String, filter: String, propertyKey: String, minValue: Float, maxValue: Float, defaultValue: Float) {
        self.title = title
        self.filter = filter
        self.propertyKey = propertyKey
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue
        self.currentValue = defaultValue
    }
}
