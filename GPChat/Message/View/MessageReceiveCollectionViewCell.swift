//
//  MessageReceiveCollectionViewCell.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/29.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import YYKit

class MessageReceiveCollectionViewCell: MessageRootCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        userImageView.frame = CGRect.init(x: 15, y: 5, width: 40, height: 40)
        voiceTimeLabel.textAlignment = .left
        
        activityView?.backgroundColor = UIColor.clear
        activityView?.activityIndicatorViewStyle = .white
        
        errorBtn = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleModel(model: MessageModel?) {
        super.handleModel(model: model)
        if let model = model {
            imageView.frame = CGRect.init(x: 60, y: 5, width: model.width + 10, height: model.height)
            textView.frame = CGRect.init(x: imageView.left + 8.5, y: model.height == 40 ? 10: 6, width: model.width, height: model.height)
            
            model.mediaImageView?.center = imageView.center
            model.mediaImageView?.centerX -= 7.5 / 2 + 2
            
            if model.mediaImageView != nil {
//                activityView?.frame = CGRect.init(x: model.mediaImageView!.frame.maxX + 5, y: height / 2 - 10, width: 20, height: 20)
                activityView?.center = model.mediaImageView!.center
                bringSubview(toFront: activityView!)
            }
            
            voiceBtn.frame = textView.frame
            voiceBtn.centerY -= 5
            voiceBtn.centerX -= 1

            voiceTimeLabel.frame = CGRect.init(x: imageView.frame.maxX + 5, y: height - 25, width: 35, height: 20)
            
            
        }
    }
}
