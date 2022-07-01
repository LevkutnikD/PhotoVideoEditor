//
//  PropertyCollection.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 27.04.2022.
//

import Foundation

enum PropertyCollection {
    case sharpness
    case highlights
    case shadows
    case contrast
    case saturation
    case brightness
    
    func components() -> Property {
        switch self {
        case .sharpness:
            return Property(title: "Sharpness",
                            filter: "CISharpenLuminance",
                            propertyKey: "inputSharpness",
                            minValue: 0,
                            maxValue: 2,
                            defaultValue: 0.40)
        case .highlights:
            return Property(title: "Highlights",
                            filter: "CIHighlightShadowAdjust",
                            propertyKey: "inputHighlightAmount",
                            minValue: 0,
                            maxValue: 2,
                            defaultValue: 1.0)
        case .shadows:
            return Property(title: "Shadows",
                            filter: "CIHighlightShadowAdjust",
                            propertyKey: "inputShadowAmount",
                            minValue: 0,
                            maxValue: 2,
                            defaultValue: 0.0)
        case .contrast:
            return Property(title: "Contrast",
                            filter: "CIColorControls",
                            propertyKey: "inputContrast",
                            minValue: 0,
                            maxValue: 2,
                            defaultValue: 1.0)
        case .saturation:
            return Property(title: "Saturation",
                            filter: "CIColorControls",
                            propertyKey: "inputSaturation",
                            minValue: 0,
                            maxValue: 2,
                            defaultValue: 1.0)
        case .brightness:
            return Property(title: "Brightness",
                            filter: "CIColorControls",
                            propertyKey: "inputBrightness",
                            minValue: 0,
                            maxValue: 0.3,
                            defaultValue: 0.0)
        }
    }
}


