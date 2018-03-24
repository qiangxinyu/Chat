//
//  MessageModel.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/30.
//  Copyright © 2017年 强新宇. All rights reserved.
//


import UIKit
import EZAudio
import YYKit

let messageMaxWidth = kScreenWidth - 165
let cellAddHeight: CGFloat = 10
let sizeLabel = UITextView()

class MessageModel: NSObject {
    var messageBaseModel: MessageBaseModel
    var userInfo = UserInfo()

    var targetID = ""
    var tableName: String {
        get {
            return "tb_" + targetID
        }
    }
    
    
    
    var cellType: MessageCellType? = MessageCellType.Sender
    var type: MessageData.MessageDataType? = MessageData.MessageDataType.none
    var status: MessageStatus? = MessageStatus.Normal
    
    var height = CGFloat()
    var width = CGFloat()
    
    var attributed: NSMutableAttributedString?
    var indexPath = IndexPath.init(row: 0, section: 0)
    var image: UIImage?
    
    var audioFile: EZAudioFile?
    
    var timeString = ""
    
    var mediaImageView: UIImageView?
    var bubbleImage: UIImage?
    
    func clearSelf() {
        reloadDataHandle = nil
        clearTap()
    }
    
    func clearTap() {
        if let gestures = mediaImageView?.gestureRecognizers {
            for ges in gestures {
                mediaImageView?.removeGestureRecognizer(ges)
            }
        }
    }
    
    func initUserInfo()  {
        if cellType == .Receive ,let useri = DBManager.getUserInfo(targetID: targetID) {
            userInfo.id = useri.id
            userInfo.name = useri.name
            userInfo.avatar = useri.avatar
        } else {
            userInfo.id = selfID
            userInfo.name = selfName
            userInfo.avatar = selfAvatar
        }
    }
    
    deinit {
        print(self, "deinit")
    }
    
    
    // MARK: - init
    init(model: MessageModel) {
        messageBaseModel = MessageBaseModel()
        super.init()
        height = 30
        cellType = .Date
        timeString = Date.getTimeString1(timeInterval: model.messageBaseModel.time)
    }
    
    convenience init(voiceURL a: URL, targetID ti: String) {
        var baseModel = MessageBaseModel()
        baseModel.cellType = MessageCellType.Sender.rawValue
        baseModel.type = MessageData.MessageDataType.voice.rawValue
        baseModel.status = MessageStatus.Sending.rawValue
        baseModel.data = a.absoluteString
        baseModel.targetID = ti
        
        if let af = AudioManager.createAudioFile(url: a) {
            baseModel.voiceTime = UInt32(af.duration)
        }
        
        baseModel = baseModel.insert(targetID: ti)
        self.init(messageBaseModel: baseModel, targetID: ti)
    }
    
    convenience init(imageStr: String, image i: UIImage, targetID ti: String) {
        var baseModel = MessageBaseModel()
        baseModel.cellType = MessageCellType.Sender.rawValue
        baseModel.type = MessageData.MessageDataType.image.rawValue
        baseModel.status = MessageStatus.Sending.rawValue
        baseModel.data = imageStr
        baseModel.targetID = ti
        baseModel.imgWidth = UInt32(i.size.width)
        baseModel.imgHeight = UInt32(i.size.height)
        baseModel = baseModel.insert(targetID: ti)
        
        

        self.init(messageBaseModel: baseModel, targetID: ti, image: i.normalizedImage())
    }
    
    convenience init(text t: String , targetID ti: String) {
        var baseModel = MessageBaseModel()
        baseModel.cellType = MessageCellType.Sender.rawValue
        baseModel.type = MessageData.MessageDataType.text.rawValue
        baseModel.status = MessageStatus.Sending.rawValue
        baseModel.data = t
        baseModel.targetID = ti
        baseModel = baseModel.insert(targetID: ti)
        
        self.init(messageBaseModel: baseModel, targetID: ti)
    }
    
    init(messageBaseModel mbm: MessageBaseModel, targetID ti: String, isDB: Bool = false, image: UIImage? = nil) {
        messageBaseModel = mbm
        messageBaseModel.targetID = ti
        if mbm.status == MessageStatus.Sending.rawValue, isDB {
            messageBaseModel.status = MessageStatus.SendFailed.rawValue
        }
        super.init()
        cellType = MessageCellType(rawValue: messageBaseModel.cellType)
        type = MessageData.MessageDataType.init(rawValue: messageBaseModel.type)
        status = MessageStatus(rawValue: messageBaseModel.status)
        
        targetID = ti
        sizeLabel.font = UIFont.thirdTitleTextFont()
        
        if type == .image, self.image == nil {
            if image == nil {
                self.image = YYImageCache.shared().getImageForKey(messageBaseModel.data)?.normalizedImage()
            } else {
                self.image = image
            }
        }
        
        if type == .voice {
            if messageBaseModel.data.utf16.count > 0 && !messageBaseModel.data.hasPrefix("http") {
                if let url = URL.init(string: messageBaseModel.data) {
                    audioFile = AudioManager.createAudioFile(url: url)
                }
            }
        }
        initUserInfo()
        handleData()
    }
    
    
    
    @discardableResult
    convenience init(message m: Message, targetID ti: String) {
        let baseModel = MessageBaseModel.init(msg: m.messageData)
        self.init(messageBaseModel: baseModel, targetID: ti)
        userInfo = m.messageData.userInfo
    }
    
    // MARK: - To Data
    func modelToData() -> Data {
        
        var msgData = MessageData.init(model: messageBaseModel)
        msgData.userInfo = userInfo
        
        var msg = Message()
        msg.type = Message.MessageType.message
        msg.messageData = msgData
        msg.appID = App_ID
        
        do {
            print("send data ->",msgData)
            return try msg.serializedData()
        } catch {
            print("send data error->",error)
            return Data()
        }
    }
    
    // MARK: - DB Method
    func updateDB()  {
        print("update db \(self)")
        DBManager.update(model: self)
    }
    
    func deleteDB() {
        DBManager.delete(model: self)
    }
    
    func insertDB() {
        messageBaseModel = messageBaseModel.insert(targetID: targetID)
    }
    
    func reloadDB()  {
        deleteDB()
        messageBaseModel.MesLocalID = nil
        insertDB()
    }
    
    
    // MARK: - Handle Data
    var reloadDataHandle:(() -> Void)?

    func handleData() {
        if cellType == .Date {
            height = 40
        } else {
            if cellType == .Sender {
                var image = UIImage.init(name: "sender_bubble@3x", type: "png")
                image = image?.masked(color: UIColor.init(hexString: "5EE700")!)
                bubbleImage = image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 27, left: 5, bottom: 5, right: 10), resizingMode: .stretch)
            } else if cellType == .Receive {
                var image = UIImage.init(name: "receive_bubble@3x", type: "png")
                image = image?.masked(color: UIColor.white)
                bubbleImage = image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 27, left: 10, bottom: 5, right: 5), resizingMode: .stretch)
            }
            
            switch type {
            case .text?:
                attributed = NSMutableAttributedString.init(string: messageBaseModel.data)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byCharWrapping
                
                let linkAttributes = [
                    NSAttributedStringKey.font: UIFont.thirdTitleTextFont() ?? UIFont.init(),
                    NSAttributedStringKey.foregroundColor: UIColor.secondTitleTextColor() ?? UIColor.black
                    ,
                    NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey : Any]
                
                let url = "(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))"
                let regex = try? NSRegularExpression(pattern: url, options: .caseInsensitive)
                
                let text = messageBaseModel.data
                let tt = text as NSString
                attributed?.addAttributes(linkAttributes, range: tt.rangeOfAll())
                
                regex?.enumerateMatches(in: text, options: .reportProgress, range: tt.rangeOfAll(), using: { (r, f, u) in
                    if r == nil {return}
                    attributed?.addAttributes([.link : tt.substring(with: r!.range),.foregroundColor: UIColor.init(hexString: "157efb") ?? UIColor.blue], range: r!.range)
                })
                
                sizeLabel.frame = CGRect.init(x: 0, y: 0, width: messageMaxWidth, height: 0)
                sizeLabel.attributedText = attributed
                sizeLabel.sizeToFit()
                height = sizeLabel.height + 5
                width = sizeLabel.width + 5
            case .image?:
                print("image")
                if let image = image {
                    handleImageSize(imgWidth: image.size.width, imgHeight: image.size.height)
                    mediaImageView = UIImageView.init(image: image)
                } else {
                    handleImageSize(imgWidth: CGFloat(messageBaseModel.imgWidth), imgHeight: CGFloat(messageBaseModel.imgHeight))
                    mediaImageView = UIImageView()
                    status = MessageStatus.Sending
                    mediaImageView?.setImageWith(URL.init(string: messageBaseModel.data), placeholder: nil, options: YYWebImageOptions.init(rawValue: 0), completion: {[weak self] (image, url, type, stag, error) in
                        DispatchQueue.main.async {
                            self?.status = MessageStatus.Normal
                            self?.image = image?.normalizedImage()
                            self?.handleData()
                            self?.reloadDataHandle?()
                        }
                    })
                }
            case .voice?:
                if audioFile == nil {
                    if let url = AudioManager.getAudioURL(url: messageBaseModel.data) {
                        if let url = URL.init(string: url) {
                            audioFile = AudioManager.createAudioFile(url: url)
                            handleVoide()
                        }
                    } else {
                        NetTool.Download(url: messageBaseModel.data)
                            .success(completionHandler: {[weak self] response in
                                if let url = AudioManager.filePathURL(),
                                    let data = response as? Data
                                {
                                    print("down voice....")
                                    do {
                                        try data.write(to: url)
                                        AudioManager.setAudioURL(url: self!.messageBaseModel.data, audioURL: url.absoluteString)
                                        self?.audioFile = AudioManager.createAudioFile(url: url)
                                        self?.handleVoide()
                                        self?.reloadDataHandle?()
                                    } catch {
                                        print("voice data write file error \(error)")
                                    }
                                }
                            })
                    }
                }
                handleVoide()
            case .none:
                print("message model type none")
            case .UNRECOGNIZED(_)?:
                print("UNRECOGNIZED")
            case .some(.none):
                print("some")
            }
            
            if height < 40 {
                height = 40
            }
            
            if width > messageMaxWidth {
                width = messageMaxWidth
            }
            
            height = CGFloat(Int(height + 0.5))
            width  = CGFloat(Int(width + 0.5))
            
            if mediaImageView != nil {
                mediaImageView?.bounds = CGRect.init(x: 0, y: 0, width: width, height: height)
                mediaImageView?.clipsToBounds = true
                mediaImageView?.backgroundColor = UIColor.black
                
                let imageView = UIImageView.init(image: bubbleImage)
                imageView.frame = mediaImageView!.bounds.insetBy(dx: 2, dy: 2)
                mediaImageView?.layer.mask = imageView.layer
                
                mediaImageView?.isUserInteractionEnabled = true
            }
        }
    }
    
    func handleImageSize(imgWidth: CGFloat, imgHeight: CGFloat) {
        if imgWidth < messageMaxWidth {
            width = imgWidth
            height = imgHeight
        } else {
            width = messageMaxWidth
            height = width * imgHeight / imgWidth
        }
        
        if height > 200 {
            height = 200
            width = height * imgWidth / imgHeight
        }
    }
    
    func handleVoide() {
        
        var time:Double = 0
        if audioFile != nil {
            time = audioFile!.duration
        } else {
            time = Double(messageBaseModel.voiceTime)
        }
        let min = Int(time) / 60
        let sec = Int(time) % 60
        if min != 0 {
            timeString = "\(min)′\(sec)″"
        } else {
            timeString = "\(sec)″"
        }
        
        width = CGFloat(time / Double(20) * Double(messageMaxWidth))
        if width < 60 {
            width = 60
        } else if width > messageMaxWidth {
            width = messageMaxWidth
        }
        
        height = 40
        
    }
    
    override var description: String {
        return  super.description + "t:\(type)  w: \(width) h:\(height) mediaImageView:\(mediaImageView)  data: \(messageBaseModel.data)"
    }
}

extension Message {
    init(messageID: String) {
        type = .read
        readData = ReadData()
        readData.messageID = messageID
    }
    
    static func getSendData(messageID: String) -> Data? {
        return try? self.init(messageID: messageID).serializedData()
    }
}

