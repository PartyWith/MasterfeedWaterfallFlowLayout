//
//  PartyPicksHorizontalFlowLayout.swift
//  PartyPicksHorizontalFlowLayout
//
//  Created by Felipe Ricieri on 18/11/2017.
//  Copyright © 2017 Ricieri ME. All rights reserved.
//

import UIKit

class MasterfeedLayout : UICollectionViewFlowLayout {
    
    override class var layoutAttributesClass: AnyClass {
        return MasterfeedLayoutAttributes.self
    }
    
    var delegate: MasterfeedLayoutDelegate!
    var numberOfColumns = 2
    var cellPadding: CGFloat = 20.0
    var sectionPadding : CGFloat = 20.0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    internal var cache = [MasterfeedLayoutAttributes]()
    internal var contentHeight: CGFloat  = 0 { didSet {
        contentHeightDidChange()
        }
    }
    internal var contentWidth: CGFloat {
        //let insets = collectionView!.contentInset
        return collectionView!.bounds.width// - (insets.left + insets.right)
    }
    
    func clearCache() {
        contentHeight = 0
        cache = []
        invalidateLayout()
    }
    
    override func prepare() {
        
        //  Rows
        let columnWidth = (contentWidth - (cellPadding * CGFloat(numberOfColumns-1)) - (sectionPadding * 2)) / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append( sectionPadding + (CGFloat(column) * columnWidth) + (cellPadding * CGFloat(column)) )
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // remove Infinite Scrolling Loading wheel padding
        contentHeight = 0
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAt: indexPath, withWidth: columnWidth)
            let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAt: indexPath, withWidth: columnWidth)
            let height = photoHeight + annotationHeight + sectionPadding
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            let attributes = MasterfeedLayoutAttributes(forCellWith: indexPath)
            attributes.photoHeight = photoHeight
            attributes.frame = frame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            if  column >= (numberOfColumns - 1) {
                column = 0
            }
            else {
                column += 1
            }
        }
        
        // Inset bottom
        contentHeight += 60
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if  attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    // Listeners
    internal func contentHeightDidChange() {
        // Can be overriden
        delegate?.collectionView?(collectionView!, didUpdatedContentHeight: contentHeight)
    }
}

class MasterfeedLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! MasterfeedLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if  let attributes = object as? MasterfeedLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}
