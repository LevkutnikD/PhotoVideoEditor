//
//  ListOfMedia.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 31.05.2022.
//

import UIKit

protocol ListOfMedia {
    var savedMedia: [SavedMedia] { get }
    func selectedMediaToEdit(withInfo info: [UIImagePickerController.InfoKey : Any]) -> SavedMedia
    func reload()
}

class ListOfMediaImpl: ListOfMedia {
    
    private var storageManager: StorageManager!
    private var savedMediaStorage: [SavedMedia]!
    
    var savedMedia: [SavedMedia] {
        get {
            return savedMediaStorage
        }
    }
    
    init() {
        storageManager = StorageManagerImpl()
        fetchData()
    }
   
    private func fetchData() {
        self.savedMediaStorage = storageManager.fetchSavedMedia()
    }
    
    func selectedMediaToEdit(withInfo info: [UIImagePickerController.InfoKey : Any]) -> SavedMedia {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let selectedMedia = SavedMedia(context: managedContext)
        
        if let image = info[.originalImage] as? UIImage {
            selectedMedia.isPhoto = true
            selectedMedia.preview = image.pngData()
            selectedMedia.fileName = ""
        } else if let videoURL = info[.mediaURL] as? URL {
            selectedMedia.isPhoto = false
            selectedMedia.fileName = videoURL.lastPathComponent
        }
        
        selectedMedia.created = Date()
        selectedMedia.lastEditing = Date()
        return selectedMedia
    }
    
    func reload() {
        fetchData()
    }
}
