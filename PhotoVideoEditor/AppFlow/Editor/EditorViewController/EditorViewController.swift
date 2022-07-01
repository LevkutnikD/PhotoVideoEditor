//
//  EditorViewController.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 13.10.2021.
//

import UIKit
import CoreData
import CropViewController

class EditorViewController: UIViewController, CropViewControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    
    //MARK: - Variables
    
    @IBInspectable let heightOfPropertyeditorRatio: CGFloat = 1 / 3
    
    var selectedMedia: SavedMedia!
    var dateOfCreation: Date!
    var storageManager = StorageManagerImpl()
    var managedContext: NSManagedObjectContext!
    
    var propertyEditedImage: UIImage?
    var propertyEditor: PropertyEditor?
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rightBarButtonItem.title = "Export"
        setupUI()
    }
    
    
    //MARK: - Base
    
    func setupUI() { }
    
    func exportMedia() { }
    
    func presentCropViewController() { }
    
    func presentPropertyEditing() {
        guard let propertyEditor = propertyEditor else { return }
        let propertyEditorHeight = self.view.bounds.height * heightOfPropertyeditorRatio
        let propertyEditorView = PropertyEditorView(frame: CGRect(x: 0,
                                                                  y: self.view.bounds.maxY - propertyEditorHeight,
                                                                  width: self.view.bounds.width,
                                                                  height: propertyEditorHeight))
        propertyEditorView.propertyEditor = propertyEditor
        self.view.addSubview(propertyEditorView)
    }
    
    func setupPropertyEditor() { }
    
    @IBAction func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        exportMedia()
    }
    
    @IBAction func crop(_ sender: UIButton) {
        guard let _ = selectedMedia else { return }
        presentCropViewController()
    }
    
    @IBAction func propertyEditing(_ sender: UIButton) {
        guard let _ = selectedMedia else { return }
        setupPropertyEditor()
        presentPropertyEditing()
    }
    
}
