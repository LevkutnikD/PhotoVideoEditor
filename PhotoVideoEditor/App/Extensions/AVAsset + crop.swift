//
//  AVAsset + crop.swift
//  PhotoVideoEditor
//
//  Created by Dima Levkutnyk on 30.09.2021.
//

import UIKit
import AVFoundation
import Photos

extension AVAsset {
    
    func cropVideoTrack(at index: Int, cropRect: CGRect, angle: Int, outputURL: URL, videoWidth: CGFloat, videoHeight: CGFloat, completion: @escaping (Result<Void, Swift.Error>) -> Void) {
        
        guard let videoTrack = self.tracks(withMediaType: AVMediaType.video).first else {
            return
        }

        let size = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
        
        let originalSize = CGSize(width: abs(size.width), height: abs(size.height))
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = cropRect.size
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: CMTime(seconds: 60, preferredTimescale: 30))
    
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        
        var finalTransform: CGAffineTransform! = videoTrack.preferredTransform
        
        if angle == 90 || angle == -270 {
            finalTransform = finalTransform.concatenating(CGAffineTransform(rotationAngle: CGFloat(90.0 * .pi / 180)))
            finalTransform = finalTransform.concatenating(CGAffineTransform(translationX: originalSize.height, y: 0))
            finalTransform = finalTransform.concatenating(CGAffineTransform(translationX: -cropRect.minX, y: -cropRect.minY))
        } else if angle == -90 || angle == 270 {
            
            finalTransform = finalTransform.concatenating(CGAffineTransform(rotationAngle: CGFloat(-90.0 * .pi / 180)))
            finalTransform = finalTransform.concatenating(CGAffineTransform(translationX: 0, y: originalSize.width))
            finalTransform = finalTransform.concatenating(CGAffineTransform(translationX: -cropRect.minX, y: -cropRect.minY))
            
        } else if angle == 180 || angle == -180 {
            finalTransform = finalTransform.concatenating(CGAffineTransform(rotationAngle: CGFloat(180.0 * .pi / 180)))
            finalTransform = finalTransform.concatenating(CGAffineTransform(translationX: originalSize.width, y: originalSize.height))
            finalTransform = finalTransform.concatenating(CGAffineTransform(translationX: -cropRect.minX, y: -cropRect.minY))
        } else {
            finalTransform = finalTransform.concatenating(CGAffineTransform(translationX: -cropRect.minX, y: -cropRect.minY))
        }
        
        transformer.setTransform(finalTransform, at: CMTime.zero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exporter = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        exporter?.outputURL = outputURL
        exporter?.outputFileType = AVFileType.mov
        
        exporter?.exportAsynchronously(completionHandler: { [weak exporter] in
            DispatchQueue.main.async {
                if let error = exporter?.error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        })
    }
}




