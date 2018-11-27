//
//  CollectionViewCell.swift
//  CollectionViewTesting
//
//  Created by sandeep bhandari on 28/11/18.
//  Copyright © 2018 sandeep bhandari. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    var imageURL: URL! = nil
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(with url : URL) {
        self.imageURL = url
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, _, url) in
            if self.imageURL == url {
                self.imageView.image = image
            }
        }
    }

}
