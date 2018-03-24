//
//  UIButton+Utils.swift
//  GPChat
//
//  Created by 强新宇 on 2018/1/19.
//  Copyright © 2018年 强新宇. All rights reserved.
//

import UIKit

extension UIButton {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let width = max(44 - bounds.size.width, 0)
        let height = max(44 - bounds.size.height, 0)
        
        let nb = bounds.insetBy(dx: -0.5 * width, dy: -0.5 * height)
        return nb.contains(point)
    }
    
    
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        print("btn touchesBegan")
//    }
//
//
//    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        print("btn touchesEnded")
//
//    }
}
