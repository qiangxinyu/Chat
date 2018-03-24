//
//  UIScrollView+Scroll.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/5.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation
extension UIScrollView {
    func scrollToBottom() {
        scrollToBottom(animated: true)
    }
    
    func scrollToBottom(animated: Bool) {
        var y = contentSize.height - height
        if y < 0 {
            y = 0
        }
        setContentOffset(CGPoint.init(x: contentOffset.x, y: y), animated: animated)
    }
}
