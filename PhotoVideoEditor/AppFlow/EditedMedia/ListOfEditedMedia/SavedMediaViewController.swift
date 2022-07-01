//
//  SavedMediaViewController.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 11.10.2021.
//

import UIKit
import CoreData
import AVFoundation

final class SavedMediaViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var savedMediaCollectionView: UICollectionView!
    @IBOutlet weak var selectMediaBarButtonItem: UIBarButtonItem!
    
    
    //MARK: - Variables
    
    let listOfMedia: ListOfMedia = ListOfMediaImpl()
    let mediaSelectionSources: [MediaSelection] = [PhotoFromLibrary(), VideoFromLibrary()]
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    
    //MARK: - Setup view
    
    func reload() {
        listOfMedia.reload()
        savedMediaCollectionView.reloadData()
    }
    
    
    //MARK: - Setup collectionView layout
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: savedMediaCollectionView.frame.width / 2 - 30, height: savedMediaCollectionView.frame.height / 3)

        savedMediaCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    
    //MARK: - Select new media to edit
    
    func selectMedia() {
        let selectVideoAlertController = UIAlertController(title: "Source", message: nil, preferredStyle: .alert)
        for source in mediaSelectionSources {
            let sourceAction = UIAlertAction(title: source.sourceTitle, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.presentMediaPicker(withSource: source)
            }
            selectVideoAlertController.addAction(sourceAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        selectVideoAlertController.addAction(cancelAction)
        
        self.present(selectVideoAlertController, animated: true, completion: nil)
    }
    
    
    private func presentMediaPicker(withSource source: MediaSelection) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.allowsEditing = false
        mediaPicker.sourceType = source.sourceType
        mediaPicker.mediaTypes = source.mediaTypes
        mediaPicker.delegate = self
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    @IBAction func selectNewVideo(_ sender: UIBarButtonItem) {
        selectMedia()
    }
    
    
    //MARK: - Navigation
    
    func navigate(withMedia media: SavedMedia, asset: AVAsset? = nil) {
        var editingVC: EditorViewController!
        if media.isPhoto {
            editingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
        } else {
            editingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoEditorViewController") as! VideoEditorViewController
            if let vc = editingVC as? VideoEditorViewController {
                vc.asset = asset
            }
        }
        editingVC.selectedMedia = media
        editingVC.dateOfCreation = media.created ?? Date()
        
        self.navigationController?.pushViewController(editingVC, animated: true)
    }

}


//MARK: - CollectionViewDataSource

extension SavedMediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfMedia.savedMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionViewCell
        if let preview = listOfMedia.savedMedia[indexPath.row].preview, let image = UIImage(data: preview) {
            cell.mediaImageView.image = image
        }
        return cell
    }
}


//MARK: - CollectionViewDelegate

extension SavedMediaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let savedMedia = listOfMedia.savedMedia[indexPath.row]
        navigate(withMedia: savedMedia)
    }
}


//MARK: - Pick media from galery

extension SavedMediaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var asset: AVAsset?
        let selectedMedia = listOfMedia.selectedMediaToEdit(withInfo: info)
        
        if let videoURL = info[.mediaURL] as? URL {
            asset = AVAsset(url: videoURL)
        }
        
        dismiss(animated: true) {
            self.navigate(withMedia: selectedMedia, asset: asset)
        }
    }
}
