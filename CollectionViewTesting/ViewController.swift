//
//  ViewController.swift
//  CollectionViewTesting
//
//  Created by sandeep bhandari on 27/11/18.
//  Copyright © 2018 sandeep bhandari. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var imageURL = ["https://homepages.cae.wisc.edu/~ece533/images/airplane.png","","https://homepages.cae.wisc.edu/~ece533/images/arctichare.png","https://homepages.cae.wisc.edu/~ece533/images/baboon.png","https://homepages.cae.wisc.edu/~ece533/images/boat.png","https://homepages.cae.wisc.edu/~ece533/images/cat.png","https://homepages.cae.wisc.edu/~ece533/images/barbara.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.register(UINib(nibName:"HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "horizontalCell")
        self.collectionView.register(UINib(nibName:"CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }


}

extension ViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let urlString = imageURL[indexPath.row % 6]
        if urlString == "" {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCell", for: indexPath) as? HorizontalCollectionViewCell {
                cell.update()
                return cell
            }
        }
        else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? CollectionViewCell {
                cell.updateCell(with: URL(string: imageURL[indexPath.row % 6])!)
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.size.width, height: 180)
    }
}

