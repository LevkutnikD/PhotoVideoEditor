//
//  ViewController.swift
//  VideoEditor
//
//  Created by Dmitriy Levkutnik on 30.09.2021.
//

import UIKit
import CropViewController
import AVFoundation
import CoreData

final class VideoEditorViewController: EditorViewController {
    
    //MARK: - Variables
    
    var asset: AVAsset?
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var item : AVPlayerItem!
    private var defaultPlayerLayerFrame: CGRect!
    private var originalMediaSize: CGSize!
    
    
    //MARK: - Setup UI
    
    override func setupUI() {
        setupUIWithVideo()
    }
    
    
    //MARK: - Setup UI with AVAsset
    
    func setupUIWithVideo() {
        guard let selectedMedia = selectedMedia else { return }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask)[0]
        let videoURL = documentDirectory.appendingPathComponent(selectedMedia.fileName!)
        
        if self.asset == nil {
            self.asset = AVAsset(url: videoURL)
        }
        
        let naturalSize = asset!.resolutionForLocalVideo()
        
        self.item = AVPlayerItem(asset: asset!)
        
        player = AVPlayer(playerItem: item)
        playerLayer = AVPlayerLayer(player: player)
        
        if let size = naturalSize {
            if size.width >= size.height {
                let newHeight = (size.height * self.view.bounds.width) / size.width
                playerLayer?.frame = CGRect(x: 0, y: self.view.frame.midY - (newHeight / 2), width: self.view.frame.width, height: newHeight)
            } else {
                playerLayer!.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.maxY)! * 2.5)
            }
        } else {
            playerLayer!.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.maxY)! * 2.5)
        }
        
        self.view!.layer.addSublayer(playerLayer!)
        self.view!.layer.insertSublayer(playerLayer!, at: 0)
        player!.play()
    }
    
    
    //MARK: - Change video after editing
    
    func changeCurrentVideo(onVideoAtPath path: URL) {
        DispatchQueue.main.async {
            self.player!.pause()
            self.playerLayer!.removeFromSuperlayer()
            self.setupUIWithVideo()
        }
    }
    
    
    //MARK: - Present CropVC
    
    override func presentCropViewController() {
        self.asset!.createVideoThumbnail(view: self.view) { image in
            self.originalMediaSize = CGSize(width: image.size.width, height: image.size.height)
            
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            self.present(cropViewController, animated: true, completion: nil)
        }
        
    }
    
    
    //MARK: - Export media
    
    override func exportMedia() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask)[0]
        let url = documentDirectory.appendingPathComponent(selectedMedia.fileName!)
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
    }
}


//MARK: - Crop delegate

extension VideoEditorViewController {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask)[0]
        let num = Int.random(in: 0...Int.max)
        let fileName = documentDirectory.appendingPathComponent("movie\(num).mov")
        
        asset!.cropVideoTrack(at: 0, cropRect: cropRect, angle: angle, outputURL: fileName, videoWidth: self.originalMediaSize.width, videoHeight: self.originalMediaSize.height) { [weak self] _ in
            guard let self = self else { return }
            self.storageManager.removeFromDocumentDirectory(itemWithName: self.selectedMedia.fileName!)
            self.changeCurrentVideo(onVideoAtPath: fileName)
            self.asset = AVAsset(url: fileName)
            
            self.storageManager.save(video: self.selectedMedia, withName: fileName.lastPathComponent, preview: image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}


