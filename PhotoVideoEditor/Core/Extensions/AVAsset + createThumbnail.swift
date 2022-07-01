//
//  AVAsset + createThumbnail.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 08.10.2021.
//

import UIKit
import AVFoundation

extension AVAsset {
    
    func createVideoThumbnail(view: UIView, completion: @escaping (UIImage) -> ()) {
        let asset = self
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        DispatchQueue.main.async {
            assetImgGenerate.maximumSize = CGSize(width: view.frame.width, height: view.frame.height)
        }

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            completion(thumbnail)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}
