//
//  RecorderView.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/21.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

class RecorderView: UIView {

    let volumeView = VolumeView()
    let label = UILabel()
    let backgroundView = UIView()
   
    class func share() -> RecorderView {
        let view = RecorderView()
        
        view.frame = CGRect.init(x: 0, y: 0, width: 160, height: 160)
        view.center = CGPoint.init(x: kScreenWidth / 2, y: kScreenHeight / 2)
        view.isHidden = true
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        view.backgroundView.frame = view.bounds
        view.backgroundView.backgroundColor = UIColor.black
        view.backgroundView.alpha = 0.4
        
        view.volumeView.backgroundColor = UIColor.clear
        view.volumeView.frame = CGRect.init(x: 12, y: 35, width: 160 - 24, height: 65)
        
        view.label.frame = CGRect.init(x: 0, y: 160 - 12 - 20, width: 160, height: 20)
        view.label.text = "上滑手指,取消发送"
        view.label.textColor = UIColor.white
        view.label.textAlignment = .center
        view.label.font = UIFont.thirdTitleTextFont()
        
        view.addSubview(view.backgroundView)
        view.addSubview(view.volumeView)
        view.addSubview(view.label)
        return view
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func DBChange(db: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.volumeView.db = CGFloat(db)
            self?.volumeView.setNeedsDisplay()
        }
    }
    
    func inside() {
        label.text = "上滑手指,取消发送"
    }
    
    func outside() {
        label.text = "松开手指,取消发送"
        volumeView.db = -100
        volumeView.setNeedsDisplay()
    }
    
    func timeShort()  {
        label.text = "录制时间太短"
        volumeView.db = -100
        volumeView.setNeedsDisplay()
    }
}


class VolumeView: UIView {
    var db: CGFloat = 0.0
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
//        print("db is \(db)")

        if db == -100 {
            for i in 0...10 {
                let rectanglePath = UIBezierPath(roundedRect: CGRect(x: CGFloat(i) * 16, y: rect.size.height / 2 - 4, width: 8, height: 8), cornerRadius: 4)
                UIColor.white.setFill()
                rectanglePath.fill()
            }
            return
        }
        
        
        if db < 20 {
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: rect.size.height / 2 - 4, width: rect.size.width, height: 10), cornerRadius: 4)
            UIColor.white.setFill()
            rectanglePath.fill()
        } else {
            if db > 80 { db = 80 }
            
            for i in 0...1 {
                let rectanglePath = UIBezierPath(roundedRect: CGRect(x: i == 0 ? 0 : rect.maxX - 40, y: rect.size.height / 2 - 4, width: 40, height: 8), cornerRadius: 4)
                UIColor.white.setFill()
                rectanglePath.fill()
                
            }
            
            
            for i in 0...4 {
                
                var maxHeight: CGFloat

                switch i {
                case 0:
                    maxHeight = 30
                case 1:
                    maxHeight = 60
                case 2:
                    maxHeight = 15
                case 3:
                    maxHeight = 65
                default:
                    maxHeight = 25
                }
                
                var height = db / 60 * maxHeight

                if height > maxHeight {
                    height = maxHeight
                }
                if height < 8 {
                    height = 8
                }
                
                let y = rect.size.height / 2 - height / 2
                
                
                let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 32 + CGFloat(i * 16), y: y, width: 8, height: height), cornerRadius: 4)
                
                UIColor.white.setFill()
                rectanglePath.fill()
            }
        }
        
        
        
        
        
    }
}
