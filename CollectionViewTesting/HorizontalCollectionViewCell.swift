//
//  HorizontalCollectionViewCell.swift
//  CollectionViewTesting
//
//  Created by sandeep bhandari on 28/11/18.
//  Copyright © 2018 sandeep bhandari. All rights reserved.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var videoURL = ["http://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4","http://techslides.com/demos/samples/sample.mp4","http://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4","http://techslides.com/demos/samples/sample.mp4","http://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4","http://techslides.com/demos/samples/sample.mp4"]
    
    var imageURL = ["https://homepages.cae.wisc.edu/~ece533/images/airplane.png","https://homepages.cae.wisc.edu/~ece533/images/arctichare.png","https://homepages.cae.wisc.edu/~ece533/images/baboon.png","https://homepages.cae.wisc.edu/~ece533/images/boat.png","https://homepages.cae.wisc.edu/~ece533/images/cat.png","https://homepages.cae.wisc.edu/~ece533/images/barbara.png"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName:"VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "videoCell")
        // Initialization code
    }
    
    func update() {
        self.collectionView.reloadData()
    }
}

extension HorizontalCollectionViewCell : UICollectionViewDelegate {
    
}

extension HorizontalCollectionViewCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as? VideoCollectionViewCell {
            let urlString = videoURL[indexPath.row % 6]
            cell.canPlayVideo = false
            cell.indexPath = indexPath.row
            cell.updateView(with: URL(string: imageURL[indexPath.row % 6])!, video: URL(string: urlString)!)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HorizontalCollectionViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.size.width - 60, height: 180)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleCells = self.collectionView.visibleCells
        for cell in visibleCells {
            if self.collectionView.bounds.contains(cell.frame) {
                (cell as! VideoCollectionViewCell).canPlayVideo = true
            }
            else {
                (cell as! VideoCollectionViewCell).canPlayVideo = false
            }
            (cell as! VideoCollectionViewCell).prepareLoadingVideo()
        }
    }
}
