//
//  MessageRootCollectionViewCell.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/30.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

let textview_clear_select_range_key = "textview_clear_select_range_key"

class MessageRootCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var userImageView = UIImageView()
    var textView = MessageTextView()
    var imageView = UIImageView()
    var activityView:UIActivityIndicatorView? = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    var errorBtn:UIButton? = UIButton()
    var voiceBtn = UIButton()
    var voiceTimeLabel = UILabel()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print(self,"deinit")
        removeAllSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.removeFromSuperview()
        backgroundColor = UIColor.init(hexString: "EAEBEC")
        
        
        voiceTimeLabel.backgroundColor = backgroundColor
        voiceTimeLabel.font = UIFont.contentTextFont()
        voiceTimeLabel.textColor = UIColor.thirdTitleTextColor()
        voiceTimeLabel.textAlignment = .right
        
        voiceBtn.setImage(UIImage.init(name: "message_voice_icon@3x", type: "png"), for: .normal)
        voiceBtn.addTarget(self, action: #selector(clickVoiceBtn), for: .touchUpInside)
        
        userImageView.backgroundColor = backgroundColor
        userImageView.frame = CGRect.init(x: frame.size.width - 55, y: 5, width: 40, height: 40)
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        
        imageView.backgroundColor = backgroundColor
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.backgroundColor = UIColor.clear

        NotificationCenter.default.addObserver(self, selector: #selector(clearSelectRange), name: NSNotification.Name.init(rawValue: textview_clear_select_range_key), object: nil)

        activityView?.backgroundColor = backgroundColor
        activityView?.isHidden = true
        activityView?.startAnimating()
       
        
        errorBtn?.setImage(UIImage.init(name: "send_message_error@3x", type: "png"), for: .normal)
        errorBtn?.backgroundColor = backgroundColor
        errorBtn?.addTarget(self, action: #selector(clickErrorBtn), for: .touchUpInside)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tapHandle: (() -> Void)?
    var clickImageHandle: ((MessageModel, CGRect?) -> Void)?

    @objc func clearSelectRange() {
        textView.selectedRange = NSRange.init()
    }
    
    // MARK: - Click Method
    var errorHandle: ((MessageModel) -> Void)?
    @objc func clickErrorBtn() {
        tapHandle?()
        if model != nil {
            errorHandle?(model!)
        }
    }
    
    
    @objc func clickVoiceBtn() {
        if AudioManager.Default.player.state == .playing {
            AudioManager.stop()
        } else {
            AudioManager.play(file: model?.audioFile)
        }
        tapHandle?()
    }
    
    // MARK: - Handle Data
    var model: MessageModel? {
        willSet {
            handleModel(model: newValue)
        }
    }
    
    func handleModel(model: MessageModel?) {
        if let model = model {
            removeAllSubviews()
            addSubview(userImageView)
            
            if let url = URL.init(string: model.userInfo.avatar) {
                userImageView.setImageWith(url, placeholder: UIImage.init(name: "my_default_avatar@3x", type: "png"))
            }
            
            if activityView != nil {
                addSubview(activityView!)
            }
            if errorBtn != nil {
                addSubview(errorBtn!)
            }
            activityView?.startAnimating()

            imageView.image = model.bubbleImage
            switch model.type {
            case .text?:
                addSubview(imageView)
                addSubview(textView)
                textView.attributedText = model.attributed
            case .voice?:
                addSubview(imageView)
                addSubview(voiceBtn)
                addSubview(voiceTimeLabel)
                voiceTimeLabel.text = model.timeString
            case .image?:
                if model.mediaImageView == nil {
                    break
                }
                addSubview(model.mediaImageView!)
                model.clearTap()
                let tap = UITapGestureRecognizer.init(actionBlock: {[weak self] t in
                    self?.tapHandle?()
                    self?.clickImageHandle?(model,model.mediaImageView?.convert(model.mediaImageView!.bounds, to: kWindow!))
                })
                model.mediaImageView?.addGestureRecognizer(tap)
            case .none:
                print("cell  none")
            case .UNRECOGNIZED(_)?:
                print("UNRECOGNIZED")
            case .some(.none):
                print("some")
            }
            handleStatus(model: model)
        }
    }
    
    func handleStatus(model: MessageModel) {
        switch model.status {
        case .Sending?:
            activityView?.isHidden = false
            errorBtn?.isHidden = true
        case .SendFailed?:
            activityView?.isHidden = true
            activityView?.stopAnimating()
            errorBtn?.isHidden = false
        default: //normal  none
            errorBtn?.isHidden = true
            activityView?.isHidden = true
            activityView?.stopAnimating()
        }
    }
    
   
    // MARK: - TextView Delegate
    var clickURLHanlde: ((URL) -> Void)?
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        clickURLHanlde?(URL)
        return false
    }
    
}
