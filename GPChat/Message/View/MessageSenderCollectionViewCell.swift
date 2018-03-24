//
//  MessageSenderCollectionViewCell.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/23.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import YYKit
class MessageSenderCollectionViewCell: MessageRootCollectionViewCell {
  
    override func handleModel(model: MessageModel?) {
        super.handleModel(model: model)
        if let model = model {
            imageView.frame = CGRect.init(x: kScreenWidth - model.width - 5 - 60 - 5, y: 5, width: model.width + 10, height: model.height)
            textView.frame = CGRect.init(x: imageView.left + 3, y: model.height == 40 ? 10: 6, width: model.width, height: model.height)
            
            model.mediaImageView?.center = imageView.center
            model.mediaImageView?.centerX += 7.5 / 2 + 2
            
            voiceBtn.frame = textView.frame
            voiceBtn.centerY -= 5
            voiceBtn.centerX -= 1
            
            voiceTimeLabel.sizeToFit()
            voiceTimeLabel.left = voiceBtn.frame.minX - voiceTimeLabel.width - 10
            voiceTimeLabel.top = height - voiceTimeLabel.height - 5
            
            var x: CGFloat
            if model.type == .voice {
                x = voiceTimeLabel.frame.minX - 25
            } else {
                x = textView.frame.minX - 30
            }
            
            activityView?.frame = CGRect.init(x: x, y: height / 2 - 10, width: 20, height: 20)
            errorBtn?.frame = activityView?.frame ?? CGRect.zero
        }
    }
    
    override func clickErrorBtn() {
        super.clickErrorBtn()
    }
}



