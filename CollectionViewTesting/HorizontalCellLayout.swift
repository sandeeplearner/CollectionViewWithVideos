//
//  HorizontalCellLayout.swift
//  CollectionViewTesting
//
//  Created by sandeep bhandari on 28/11/18.
//  Copyright © 2018 sandeep bhandari. All rights reserved.
//

import UIKit

class HorizontalCellLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let _: CGSize = self.collectionView!.bounds.size
        let rectBounds: CGRect = self.collectionView!.bounds
        let halfWidth: CGFloat = (rectBounds.size.width * CGFloat(0.50))
        let proposedContentOffsetCenterX: CGFloat = proposedContentOffset.x + halfWidth
        
        let proposedRect: CGRect = self.collectionView!.bounds
        
        let attributesArray:NSArray = self.layoutAttributesForElements(in: proposedRect)! as NSArray
        
        var candidateAttributes:UICollectionViewLayoutAttributes?
        
        
        for layoutAttributes in attributesArray {
            
            if let _layoutAttributes = layoutAttributes as? UICollectionViewLayoutAttributes {
                
                if _layoutAttributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                    continue
                }
                
                if candidateAttributes == nil {
                    candidateAttributes = _layoutAttributes
                    continue
                }
                
                if fabsf(Float(_layoutAttributes.center.x) - Float(proposedContentOffsetCenterX)) < fabsf(Float(candidateAttributes!.center.x) - Float(proposedContentOffsetCenterX)) {
                    candidateAttributes = _layoutAttributes
                }
                
            }
        }
        
        if attributesArray.count == 0 {
            return CGPoint(x: proposedContentOffset.x - halfWidth * 2,y: proposedContentOffset.y)
        }
        
        return CGPoint(x: candidateAttributes!.center.x - halfWidth, y: proposedContentOffset.y)
    }
}
