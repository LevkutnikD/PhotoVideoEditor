//
//  SavedMediaViewController.swift
//  PhotoVideoEditor
//
//  Created by Dima Levkutnyk on 11.10.2021.
//

import UIKit
import CoreData
import AVFoundation

class SavedMediaViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var selectMediaBarButtonItem: UIBarButtonItem!
    
    
    //MARK: - Variables
    
    var savedMedia: [SavedMedia]!
    var managedContext: NSManagedObjectContext!
    var storageManager = StorageManager()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCollectionViewLayout()
        fetchData()
    }
    
    
    //MARK: - Fetch existed objects
    
    func fetchData() {
        self.savedMedia = storageManager.fetchSavedMedia()
        mediaCollectionView.reloadData()
    }
    
    
    //MARK: - Setup collectionView layout
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: mediaCollectionView.frame.width / 2 - 20, height: mediaCollectionView.frame.height / 3)

        mediaCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    
    //MARK: - Select media
    
    func selectMedia() {
        
        let selectVideoAlertController = UIAlertController(title: "Source", message: nil, preferredStyle: .alert)
        let photo = UIAlertAction(title: "Photo from galery", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presentMediaPicker(mediaType: .photo)
        }
        let video = UIAlertAction(title: "Video from galery", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presentMediaPicker(mediaType: .video)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        selectVideoAlertController.addAction(photo)
        selectVideoAlertController.addAction(video)
        selectVideoAlertController.addAction(cancel)
        
        self.present(selectVideoAlertController, animated: true, completion: nil)
    }
    
    
    private func presentMediaPicker(mediaType: MediaType) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.allowsEditing = false
        switch mediaType {
        case .photo:
            mediaPicker.sourceType = .photoLibrary
            mediaPicker.mediaTypes = ["public.image"]
        case .camera:
            mediaPicker.sourceType = .camera
        case .video:
            mediaPicker.sourceType = .photoLibrary
            mediaPicker.mediaTypes = ["public.movie"]
        }
        mediaPicker.delegate = self
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    @IBAction func selectNewVideo(_ sender: UIBarButtonItem) {
        selectMedia()
    }

}


//MARK: - CollectionViewDataSource

extension SavedMediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionViewCell
        if let image = UIImage(data: savedMedia[indexPath.row].preview!) {
            cell.mediaImageView.image = image
        }
        return cell
    }
}


//MARK: - CollectionViewDelegate

extension SavedMediaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let savedMedia = savedMedia[indexPath.row]
        var editingVC: EditorViewController!
        if savedMedia.isPhoto {
            editingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
        } else {
            editingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoEditorViewController") as! VideoEditorViewController
        }
        editingVC.selectedMedia = savedMedia
        editingVC.dateOfCreation = Date()
        
        self.navigationController?.pushViewController(editingVC, animated: true)
    }
}


//MARK: - Pick media from galery

extension SavedMediaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedMedia = SavedMedia(context: managedContext)
        var asset: AVAsset?
        
        if let image = info[.originalImage] as? UIImage {
            selectedMedia.isPhoto = true
            selectedMedia.preview = image.pngData()
            selectedMedia.fileName = ""
        } else if let videoURL = info[.mediaURL] as? URL {
            selectedMedia.isPhoto = false
            selectedMedia.fileName = videoURL.lastPathComponent
            asset = AVAsset(url: videoURL)
        }
        
        
        selectedMedia.created = Date()
        selectedMedia.lastEditing = Date()
        
        var editingVC: EditorViewController!
        if selectedMedia.isPhoto {
            editingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
        } else {
         editingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoEditorViewController") as! VideoEditorViewController
            if let vc = editingVC as? VideoEditorViewController {
                vc.asset = asset
            }
        }
        editingVC.selectedMedia = selectedMedia
        editingVC.dateOfCreation = Date()
        
        dismiss(animated: true) {
            self.navigationController?.pushViewController(editingVC, animated: true)
        }
    }
    
}
