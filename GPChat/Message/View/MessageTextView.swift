//
//  MessageTextView.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/14.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

class MessageTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) ||
           action == #selector(selectAll(_:)) {
            return true
        }
        return false
    }
   
}
