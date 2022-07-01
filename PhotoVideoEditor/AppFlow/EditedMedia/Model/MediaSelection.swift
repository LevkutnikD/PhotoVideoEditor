//
//  SelectMedia.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 01.06.2022.
//

import UIKit

protocol MediaSelection {
    var sourceTitle: String { get }
    var sourceType: UIImagePickerController.SourceType { get }
    var mediaTypes: [String] { get }
}

class PhotoFromLibrary: MediaSelection {
    var sourceTitle = "Photo from galery"
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var mediaTypes = ["public.image"]
}

class VideoFromLibrary: MediaSelection {
    var sourceTitle = "Video from galery"
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var mediaTypes = ["public.movie"]
}
