//
//  MasterfeedLayoutDelegate.swift
//  MasterfeedWaterfall
//
//  Created by Felipe Ricieri on 23/11/2017.
//  Copyright © 2017 Ricieri ME. All rights reserved.
//

import UIKit

@objc protocol MasterfeedFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, withWidth width:CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, didUpdatedContentHeight contentHeight: CGFloat)
}
