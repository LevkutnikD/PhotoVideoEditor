//
//  AVAsset + resolution.swift
//  PhotoVideoEditor
//
//  Created by Dima Levkutnyk on 12.10.2021.
//

import Foundation
import AVFoundation

extension AVAsset {
    
    func resolutionForLocalVideo() -> CGSize? {
        guard let track = self.tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
}
