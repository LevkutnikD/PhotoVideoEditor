//
//  ProperyEditor.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 27.04.2022.
//

import UIKit
import CoreImage

class PropertyEditor {
    
    let properties: [Property] = [PropertyCollection.brightness.components(),
                                  PropertyCollection.contrast.components(),
                                  PropertyCollection.shadows.components(),
                                  PropertyCollection.highlights.components(),
                                  PropertyCollection.saturation.components(),
                                  PropertyCollection.sharpness.components()]
    
    var currentlyChangedProperty: Property? {
        didSet {
            guard let _ = currentlyChangedProperty else { return }
            editImage()
        }
    }
    
    var editingImage: UIImage
    var imageEditedCompletion: ((UIImage) -> ())?
    var context = CIContext()
    
    init(image: UIImage) {
        self.editingImage = image
    }
    
    func editImage() {
        DispatchQueue.global(qos: .userInteractive).async {
            var filteredImage = CIImage(image: self.editingImage)
            for property in self.properties {
                filteredImage = self.apply(property: property, toImage: filteredImage)
            }
            guard let filteredImage = filteredImage else { return }
            guard let outputCGImage = self.context.createCGImage(filteredImage, from: filteredImage.extent) else { return }
            let finalImage = UIImage(cgImage: outputCGImage, scale: self.editingImage.scale, orientation: self.editingImage.imageOrientation)
            DispatchQueue.main.async {
                self.imageEditedCompletion?(finalImage)
            }
        }
    }
    
    func apply(property: Property, toImage image: CIImage?) -> CIImage? {
        guard let filter = CIFilter(name: property.filter) else { return nil }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(property.currentValue, forKey: property.propertyKey)
        return filter.outputImage
    }

}
