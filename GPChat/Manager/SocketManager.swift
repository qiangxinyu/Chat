//
//  SocketManager.swift
//  TestStcket
//
//  Created by 强新宇 on 2017/11/7.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import SocketRocket

public enum SocketStaus: String {
    case Close = "已断开"
    case Open = "已链接"
    case Opening = "连接中"
    case none = ""
}

let receiveMessageKey = NSNotification.Name.init("receiveMessageKey")
let chatChangeKey = NSNotification.Name.init("chatChangeKey")
let socketStatusChangeKey = NSNotification.Name.init("socketStatusChangeKey")

public class SocketManager: NSObject, SRWebSocketDelegate {
   
    class func start() {
        let _ = Default
    }
    
    public static let Default = SocketManager()
    
    public var ws: SRWebSocket?
    var hasNetwork = false
    var status = SocketStaus.none {
        didSet {
            NotificationCenter.default.post(name: socketStatusChangeKey, object: status)
        }
    }
    var connectCount = 5
    
    public class func getStatus() -> SocketStaus {
        return Default.status
    }

    fileprivate override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NetworkManager.networkStatusHandle(networkStatusHandle: {[weak self] hasNetwork in
            print("hasNetwork",hasNetwork)
            self?.hasNetwork = hasNetwork
            if hasNetwork {
                if self?.status == .none {
                    return
                }
                self?.reconnect()
            } else {
                self?.ws?.close()
                self?.status = .Close
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //ibm  google  录音转文字
    // MARK: - App Method
    var isBackground = false
    @objc func becomeActive() {
        reconnect()
//        isBackground = false
    }
    
    @objc func enterBackground() {
//        isBackground = true
        close()
    }
    
    
    // MARK: - WS Method
    
    
    public func reconnect()  {
        if status != .Close {
            return
        }
        
        if !hasNetwork || connectCount == 0 {
            status = .Close
            connectCount = 5
            print("zero", connectCount)
        } else {
            open()
            connectCount -= 1
            print("connecting", connectCount)
        }
    }
    
    // MARK: - Method
  
    public func close()  {
        ws?.close()
        status = .Close
    }
    
    public func open() {
        if ws?.readyState == SRReadyState.OPEN && hasNetwork {
            return
        }
        let url = "ws://60.205.231.127/\(selfID)_\(selfToken)"
        print(url)
        ws = SRWebSocket.init(url: URL.init(string: url))
        ws?.delegate = self
        ws?.open()
        status = .Opening
    }
    
    
    public class func setting(id: String, name: String, token: String, avatar: String? = nil) {
        selfID = id
        selfToken = token
        selfName = name
        
        if avatar != nil {
            selfAvatar = avatar!
        }
    }
    
    
    
    public class func send(data: Any?) {
        Default.send(data: data)
    }
    
    public func send(data: Any?) {
        if data == nil {return}
        ws?.send(data)
    }
 
    // MARK: - WebSocket Delegate

    public func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("error -> \(error)")
        status = .Close
    }
    public func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        DispatchQueue.main.async {[weak self] in
            if let data = message as? Data {
                do {
                    let msg = try Message(serializedData: data)
                    if msg.type == .message {
                        MessageBaseModel.init(msg: msg.messageData).insert(targetID: msg.messageData.userInfo.id)
                        DBManager.updateChat(data: msg.messageData)
                        
//                        if self!.isBackground {
//                            print("isBackground")
//                            let localNotification = UILocalNotification()
//                            localNotification.alertBody = DBManager.getString(data: msg.messageData)
//                            localNotification.soundName = UILocalNotificationDefaultSoundName
//                            UIApplication.shared.scheduleLocalNotification(localNotification)
//                        }
                        
                        let sendData = Message.getSendData(messageID: msg.messageData.id)
                        self?.send(data: sendData)
                        
                        NotificationCenter.default.post(name: chatChangeKey , object: nil)
                    } else if msg.type == .receive {
                        DBManager.updateBaseModal(message: msg)
                    } else if msg.type == .heart {
                        self?.send(data: data)
                    }
                    print(msg)
                    NotificationCenter.default.post(name: receiveMessageKey , object: msg)
                    
                    
                } catch {
                    if let s = String.init(data: data, encoding: .utf8) {
                        selfID = s
                        print(s)
                    }
                }
            }
        }
    }
    
    public func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("open")
        status = .Open
        connectCount = 5
    }
    
    public func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        let s = String.init(data: pongPayload, encoding: .utf8)
        print("receive pong \(pongPayload)", s!)
    }
    
    public func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("close -> \(code)  \(reason), \(wasClean)")
        status = .Close
        reconnect()
    }
    
    
    public func webSocketShouldConvertTextFrame(toString webSocket: SRWebSocket!) -> Bool {
        return false
    }
}
