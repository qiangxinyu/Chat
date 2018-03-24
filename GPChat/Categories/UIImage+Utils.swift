//
//  UIImage+Color.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/5.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation
extension UIImage {
    func masked(color: UIColor) -> UIImage? {
        let imageRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -imageRect.size.height)
        context?.clip(to: imageRect, mask: cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    public convenience init?(name: String, type: String) {
        if let path = Bundle.Default().path(forResource: name, ofType: type) {
            self.init(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    func normalizedImage() -> UIImage? {
        if (imageOrientation == .up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
        draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
