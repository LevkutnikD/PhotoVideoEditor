//
//  EditorViewController.swift
//  PhotoVideoEditor
//
//  Created by Dima Levkutnyk on 13.10.2021.
//

import UIKit
import CoreData
import CropViewController

class EditorViewController: UIViewController, CropViewControllerDelegate {

    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    //MARK: - Variables
    
    var selectedMedia: SavedMedia!
    var dateOfCreation: Date!
    var storageManager = StorageManager()
    var managedContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rightBarButtonItem.title = "Export"
        setupUI()
    }
    
    func setupUI() { }
    
    func exportMedia() { }
    
    func presentCropViewController() { }
    
    @IBAction func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        exportMedia()
    }
    
    @IBAction func crop(_ sender: UIButton) {
        guard let _ = selectedMedia else { return }
        presentCropViewController()
    }
    
}
