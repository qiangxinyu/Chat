//
//  UIFont+Utils.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/10/26.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation

extension UIFont {
    class func firstTitleTextFont() -> UIFont? {
        return UIFont.init(name: "PingFangSC-Medium",  size: 17)
    }
    
    class func secondTitleTextFont() -> UIFont? {
        return UIFont.init(name: "PingFangSC-Regular",  size: 17)
    }
    
    class func thirdTitleTextFont() -> UIFont? {
        return UIFont.init(name: "PingFangSC-Regular",  size: 14)
    }
    
    class func contentTextFont() -> UIFont? {
        return UIFont.init(name: "PingFangSC-Regular",  size: 12)
    }
   
}
