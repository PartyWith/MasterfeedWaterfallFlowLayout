//
//  MasterfeedWaterfallFlowLayout.swift
//  MasterfeedWaterfall
//
//  Created by Felipe Ricieri on 18/11/2017.
//  Copyright © 2017 Ricieri ME. All rights reserved.
//

import UIKit

class MasterfeedWaterfallFlowLayout : WaterfallFlowLayout {
    
    static fileprivate(set) var headerHeight : CGFloat = 120
    static fileprivate(set) var infiniteScrollingHeight : CGFloat = 40
    
    fileprivate var allResultsLoadedLabel = UILabel(frame: CGRect.zero)
    
    override func clearCache() {
        super.clearCache()
        contentHeight = MasterfeedWaterfallFlowLayout.headerHeight
    }
    
    override func prepare() {
        
        // Section
        let header = WaterfallFlowLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(index: 0))
        header.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: collectionView!.bounds.width, height: MasterfeedWaterfallFlowLayout.headerHeight)
        cache.append(header)
        
        //  Rows
        let columnWidth = (contentWidth - (cellPadding * CGFloat(numberOfColumns-1)) - (sectionPadding * 2)) / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append( sectionPadding + (CGFloat(column) * columnWidth) + (cellPadding * CGFloat(column)) )
        }
        var column = 0
        var yOffset = [CGFloat](repeating: MasterfeedWaterfallFlowLayout.headerHeight, count: numberOfColumns)
        
        // remove Infinite Scrolling Loading wheel padding
        contentHeight = 0
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAt: indexPath, withWidth: columnWidth)
            let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAt: indexPath, withWidth: columnWidth)
            let height = photoHeight + annotationHeight + sectionPadding
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            let attributes = WaterfallFlowLayoutAttributes(forCellWith: indexPath)
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
        
        // To Infinite Scrolling Loading wheel
        if  contentHeight == 0 {
            contentHeight = MasterfeedWaterfallFlowLayout.headerHeight
        }
        
        // Prepare All Results Loaded
        prepareAllResultsLoaded()
    }
    
    override func contentHeightDidChange() {
        super.contentHeightDidChange()
        self.relocateAllResultsLoaded()
    }
}

// MARK: - All Results Label
extension MasterfeedWaterfallFlowLayout {
    
    func prepareAllResultsLoaded() {
        
        guard allResultsLoadedLabel.superview == nil else { return }
        
        allResultsLoadedLabel = UILabel(frame:
            CGRect(
                x: 0,
                y: contentHeight + MasterfeedWaterfallFlowLayout.infiniteScrollingHeight, // infinite scrolling + tab bar
                width: contentWidth,
                height: 30
            )
        )
        
        allResultsLoadedLabel.text = "People.NoMoreResults"
        allResultsLoadedLabel.textAlignment = .center
        allResultsLoadedLabel.font = UIFont.systemFont(ofSize: 13.0)
        allResultsLoadedLabel.textColor = UIColor.lightGray
        allResultsLoadedLabel.autoresizingMask = .flexibleWidth
        allResultsLoadedLabel.numberOfLines = 2
        allResultsLoadedLabel.isHidden = true
        
        collectionView?.addSubview(allResultsLoadedLabel)
    }
    
    func relocateAllResultsLoaded() {
        var rect = allResultsLoadedLabel.frame
        rect.origin.y = contentHeight + MasterfeedWaterfallFlowLayout.infiniteScrollingHeight
        allResultsLoadedLabel.frame = rect
    }
    
    func showAllResultsLoaded() {
        allResultsLoadedLabel.isHidden = false
    }
    
    func hideAllResultsLoaded() {
        allResultsLoadedLabel.isHidden = true
    }
}

/*extension PeopleNearbyViewController : MasterfeedLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        guard indexPath.row > 0 else { return 180 }
        return 240
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let descriptionTopPadding = CGFloat(3)
        let descriptionBottomPadding = CGFloat(15)
        let containerTopPadding = CGFloat(5)
        let object = viewModel.source[indexPath.item]
        
        let titleFont = PwaLFont.gothamBold(size: 13.0)
        let descriptionFont = UIFont.systemFont(ofSize: 12.0)
        
        var bio = ""
        let length = 30
        let validBio = masterfeedDescriptionAt(index: indexPath.row)
        if  validBio.characters.count > length {
            let index = validBio.index(validBio.startIndex, offsetBy: length)
            bio = validBio.substring(to: index)
        }
        
        bio = bio.replacingOccurrences(of: "\n", with: " ")
        bio = bio.replacingOccurrences(of: "\t", with: " ")
        bio = bio.replacingOccurrences(of: "\r", with: " ")
        
        // Title
        let name = "   \(masterfeedNameAt(index: indexPath.row))"
        let rectTitle = NSString(string: name)
            .boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleFont], context: nil)
        
        // Description
        let rectDescription = NSString(string: bio)
            .boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: descriptionFont], context: nil)
        
        var commentHeight = ceil(rectTitle.height + rectDescription.height)
        if  bio.characters.count == 0 {
            commentHeight = 12//rectTitle.height + 10
            if  object.jsonUser?.currently_in_city?.characters.count == 0 {
                commentHeight = 0
            }
        }
        print("⛹🏼‍♀️ Comment: \(bio), currently: \(String(describing: object.jsonUser?.currently_in_city)) width: \(width) height: \(commentHeight)")
        
        let height = commentHeight + descriptionTopPadding + descriptionBottomPadding + containerTopPadding
        return height
    }
}*/

