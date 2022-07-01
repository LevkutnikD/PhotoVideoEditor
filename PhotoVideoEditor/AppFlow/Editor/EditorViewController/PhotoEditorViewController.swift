//
//  PhotoEditorViewController.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 13.10.2021.
//

import UIKit
import CropViewController
import CoreImage

final class PhotoEditorViewController: EditorViewController {
    
    //MARK: - Variables
    
    private var editingImageView: UIImageView?
    
    
    //MARK: - Setup UI
    
    override func setupUI() {
        if let imageData = selectedMedia.preview {
            if let image = UIImage(data: imageData) {
                setupUI(withPhoto: image)
            }
        }
    }
    
    private func setupUI(withPhoto image: UIImage) {
        editingImageView = UIImageView(image: image)
        editingImageView!.frame = CGRect(x: 15, y: 75, width: self.view.frame.width - 30, height: self.view.frame.height - 150)
        editingImageView?.contentMode = .scaleAspectFit
        self.view.insertSubview(editingImageView!, at: 0)
    }
    
    
    //MARK: - Export media
    
    override func exportMedia() {
        guard let image = editingImageView?.image else { return }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
    }
    
    
    //MARK: - Present crop VC
    
    override func presentCropViewController() {
        guard let selectedMedia = selectedMedia else {
            return
        }
        if let imageData = selectedMedia.preview {
            if let image = UIImage(data: imageData) {
                let cropViewController = CropViewController(image: image)
                cropViewController.delegate = self
                self.present(cropViewController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Property editor
    
    override func setupPropertyEditor() {
        guard let editingImage = editingImageView?.image else { return }
        propertyEditor = PropertyEditor(image: editingImage)
        propertyEditor?.imageEditedCompletion = { [weak self] image in
            guard let self = self else { return }
            self.editingImageView?.image = image
        }
    }
    
}


//MARK: - CropViewControllerDelegate

extension PhotoEditorViewController {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        self.editingImageView?.image = image
        self.selectedMedia.preview = image.pngData()
        
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.storageManager.save()
        }
    }
    
}
