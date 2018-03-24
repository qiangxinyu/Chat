//
//  MessageInputView.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/16.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

class MessageInputView: UIView, UITextViewDelegate {

    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var soundRecondingBtn: UIButton!
    
    let recorderView = RecorderView.share()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        initSelf()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        initSelf()
    }
    
    func initSelf() {
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.init(hexString: "dcddde")?.cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        
        soundRecondingBtn.layer.cornerRadius = 5
        soundRecondingBtn.layer.borderColor = UIColor.init(hexString: "dcddde")?.cgColor
        soundRecondingBtn.layer.borderWidth = 1
        soundRecondingBtn.layer.masksToBounds = true
        
        kWindow?.addSubview(recorderView)
        
        AudioManager.Default.getDB {[weak self] db in
            self?.recorderView.DBChange(db: db)
        }
        
        
        var isInside = true
        let long = UILongPressGestureRecognizer.init {[weak self] (ges) in
            if let ges = ges as? UIGestureRecognizer,
               let weakSelf = self {
                
                let point = ges.location(in: weakSelf.soundRecondingBtn)
                let touchIsInside = weakSelf.soundRecondingBtn.frame.contains(point)

                print(point,weakSelf.soundRecondingBtn.bounds,touchIsInside)
                switch ges.state {
                    
                case .possible:
                    print("possible")
                case .began:
                    print("began")
                    weakSelf.soundTouchDown(weakSelf.soundRecondingBtn)
                case .changed:
                    if touchIsInside {
                        if isInside { return }
                        print("changed inside")
                        weakSelf.soundTouchInside(weakSelf.soundRecondingBtn)
                        isInside = true
                    } else {
                        if !isInside { return }
                        print("changed outside")
                        weakSelf.soundTouchOutside(weakSelf.soundRecondingBtn)
                        isInside = false
                    }
                case .ended:
                    print("ended")
                    if touchIsInside {
                        weakSelf.soundTouchUpInside(weakSelf.soundRecondingBtn)
                    } else {
                        weakSelf.soundTouchUpOutside(weakSelf.soundRecondingBtn)
                    }
                case .cancelled:
                    print("cancelled")
                case .failed:
                    print("failed")
                }
            }
            
        }
        long.cancelsTouchesInView = false
        long.minimumPressDuration = 0.15
        soundRecondingBtn.addGestureRecognizer(long)
    }

    
    // MARK: - Click Method
    @IBAction func clickVoiceBtn(_ sender: Any) {
        voiceBtn.isSelected = !voiceBtn.isSelected
        soundRecondingBtn.isHidden = !voiceBtn.isSelected
        if voiceBtn.isSelected {
            textView.resignFirstResponder()
            heightHandle?(0)
        } else {
            textView.becomeFirstResponder()
            handleHeight()
        }
    }
    
    
    var clickFunctionBtnHandle: (() -> Void)?
    @IBAction func clickFunctionBtn(_ sender: Any) {
        clickFunctionBtnHandle?()
    }
    
    @IBAction func soundTouchDown(_ sender: UIButton) {
        AudioManager.recorderStart()
        recorderView.isHidden = false
        sender.backgroundColor = UIColor.init(hexString: "9B9B9B")
        sender.setImage(UIImage.init(name: "audio_icon_touch_down@3x", type: "png"), for: .normal)
    }
    
    @IBAction func soundTouchInside(_ sender: UIButton) {
        AudioManager.microphoneStart()
        recorderView.inside()
    }
    
    @IBAction func soundTouchOutside(_ sender: UIButton) {
        AudioManager.microphoneStop()
        recorderView.outside()
    }
    
    // MARK: - Height Handle && TextView Delegate
    
    var heightHandle: ((CGFloat) -> Void)?
    
    func textViewDidChange(_ textView: UITextView) {
        handleHeight()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if textView.contentOffset.y > textView.contentSize.height - textView.height {
                textView.scrollToBottom(animated: false)
            }
        }
        
    }
    
    func handleHeight() {
        var height = textView.contentSize.height - 36 - 5
        if height < 0 {
            height = 0
        }
        if height > 81 {
            height = 81
        }
        heightHandle?(height)
    }

    
   
    
    
    // MARK: - Message Handle
    
    var audioHandle: ((URL) -> Void)?
    @IBAction func soundTouchUpInside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.init(hexString: "F4F5F7")
        sender.setImage(UIImage.init(name: "audio_icon@3x", type: "png"), for: .normal)
        
        if let url = AudioManager.recorderStop() {
            recorderView.isHidden = true
            audioHandle?(url)
        } else {
            recorderView.timeShort()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
                self?.recorderView.isHidden = true
            })
        }
    }
    
    @IBAction func soundTouchUpOutside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.init(hexString: "F4F5F7")
        sender.setImage(UIImage.init(name: "audio_icon@3x", type: "png"), for: .normal)
        AudioManager.recorderCancel()
        recorderView.isHidden = true
    }
    
    
    var textHandle: ((String) -> Void)?
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.utf16.count + text.utf16.count > 200 || text.utf16.count > 200{
            alert(message: "最多输入200个字")
            return false
        }
        if text == "\n" {
            let text = textView.text.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            if text.utf16.count == 0 {
                alert(message: "不能发送空白消息")
            } else {
                textHandle?(textView.text)
            }
            textView.text = nil
            heightHandle?(0)
            return false
        }
        return true
    }

    
    var mediaHandle: ((Bool) -> Void)?
    
    @IBAction func clickPhotoBtn(_ sender: Any) {
        mediaHandle?(true)
    }
    
    
    @IBAction func clickCameraBtn(_ sender: Any) {
        mediaHandle?(false)
    }
}
