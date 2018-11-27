//
//  VideoCollectionViewCell.swift
//  CollectionViewTesting
//
//  Created by sandeep bhandari on 27/11/18.
//  Copyright © 2018 sandeep bhandari. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher
import RxAVFoundation
import RxSwift
import RxCocoa

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var playerLayer: AVPlayerLayer? = nil
    var imageURL: URL! = nil
    var videoURL: URL! = nil
    var canPlayVideo: Bool = false
    var indexPath = -1
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepareLoadingVideo() {
        if self.canPlayVideo {
            self.cleanUpImage()
            self.loadVideo(with: videoURL)
        }
        else {
            self.cleanUpLayer()
            self.updateView(with: imageURL, video: videoURL)
        }
    }
    
    func updateView(with image: URL, video: URL) {
        self.imageURL = image
        self.videoURL = video
        self.imageView.isHidden = false
        KingfisherManager.shared.retrieveImage(with: image, options: nil, progressBlock: nil) { (image, error, _, url) in
            if self.imageURL == url {
                self.imageView.image = image
                if self.canPlayVideo == true {
                    self.loadVideo(with: video)
                }
            }
        }
    }
    
    func loadVideo(with url: URL) {
        //        DispatchQueue.global(qos: .default).async {
        let player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer?.videoGravity = .resizeAspect
        self.playerLayer?.frame = self.bounds
        
        self.playerLayer?.player?.rx.status
            .subscribe(onNext: {[weak self] (status) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.playerLayer?.player?.status == .readyToPlay {
                    strongSelf.playerLayer?.player?.play()
                }
            })
            .disposed(by: disposeBag)
        
        if #available(iOS 10.0, *) {
            self.playerLayer?.player?.rx.timeControlStatus.subscribe(onNext: {[weak self] (status) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.playerLayer?.player?.timeControlStatus == .playing {
                    strongSelf.imageView.isHidden = true
                    strongSelf.layer.insertSublayer(strongSelf.playerLayer!, at: UInt32(strongSelf.layer.sublayers?.count ?? 0))
                } else {
                    //                        videoCell?.muteButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        }
        else {
            self.playerLayer?.player?.rx.rate.subscribe(onNext: {[weak self] (rate) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.playerLayer?.player?.rate ?? 0 > Float(0) {
                    strongSelf.imageView.isHidden = true
                    strongSelf.layer.insertSublayer(strongSelf.playerLayer!, at: UInt32(strongSelf.layer.sublayers?.count ?? 0))
                } else {
                    
                }
            })
            .disposed(by: disposeBag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cleanUpLayer()
        self.cleanUpImage()
        self.disposeBag = DisposeBag()
    }
    
    func cleanUpLayer() {
        playerLayer?.player?.pause()
        playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
    }
    
    func cleanUpImage() {
        self.imageView.image = nil
        self.imageView.isHidden = false
    }
}
