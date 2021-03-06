//
//  WaterfallFlowLayoutAttributes.swift
//  MasterfeedWaterfall
//
//  Created by Felipe Ricieri on 23/11/2017.
//  Copyright © 2017 Ricieri ME. All rights reserved.
//

import UIKit

class WaterfallFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! WaterfallFlowLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if  let attributes = object as? WaterfallFlowLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}
