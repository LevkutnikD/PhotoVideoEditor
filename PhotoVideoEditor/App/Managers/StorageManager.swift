//
//  StorageManager.swift
//  PhotoVideoEditor
//
//  Created by Dima Levkutnyk on 12.10.2021.
//

import UIKit
import CoreData

final class StorageManager {
    
    private let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save(video: SavedMedia, withName name: String, preview: UIImage) {
        video.fileName = name
        video.lastEditing = Date()
        video.preview = preview.pngData()
        save()
    }
    
    func removeItemFromDocumentDirectory(withName name: String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask)[0]
        do {
            try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(name))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchSavedMedia() -> [SavedMedia] {
        var savedMedia = [SavedMedia]()
        let request: NSFetchRequest<SavedMedia> = SavedMedia.fetchRequest()
    
        do {
            let mediaArray = try managedContext.fetch(request)
            savedMedia = mediaArray.sorted { $0.created! < $1.created! }
        } catch {
            print(error.localizedDescription)
        }
        return savedMedia
    }
}
