//
//  DBManager.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/11.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

import WCDBSwift

var message_limit = 20
let documentPath = NSHomeDirectory() + "/Documents"
let baseDirectory = documentPath + "/SampleDB/GP.sqlite"

let chat_list = "chat_list"
let user_info = "user_info"

class DBManager: NSObject {
    
    static let Default = DBManager()

    let db = Database.init(withPath: baseDirectory)
    
    
    var currentChat: ChatListModel?
    var chatList = [ChatListModel]()
    var chatDic = [String: ChatListModel]()
    
    var userInfoDic = [String: UserInfo]()
    
    fileprivate override init() {
        do {
            try db.create(table: chat_list, of: ChatListModel.self)
        } catch {}
        
        do {
            try db.create(table: user_info, of: UserInfoModel.self)
        } catch {}
        
        do {
            let cl: [ChatListModel] = try db.getObjects(on: ChatListModel.Properties.all, fromTable: chat_list, where: ChatListModel.Properties.selfID == selfID, orderBy: [ChatListModel.Properties.lastMessageTime.asOrder(by: .descending)], limit: nil, offset: nil)
            for chat in cl {
                let x = chat.lastMessageTime
                chat.lastMessageTime = x
                chatList.append(chat)
                chatDic[chat.targetID] = chat
            }
        } catch {}
    }
    
    // MARK: - Chat & UserInfo
    func getString(data: MessageData) -> String {
        if data.type == .image {
            return "[图片]"
        } else if data.type == .voice {
            return "[语音]"
        }
        return data.data
    }
    
    class func getString(data: MessageData) -> String {
        return Default.getString(data: data)
    }
    
    class func updateChat(data: MessageData, targetID: String? = nil) {
        Default.updateChat(data: data, targetID: targetID)
    }
    func updateChat(data: MessageData, targetID: String? = nil) {
        let targetID = (targetID != nil) ? targetID! : data.userInfo.id
        var chatModel: ChatListModel
        let userInfo = UserInfoModel.conversion(userInfo: data.userInfo)
        
        
        if let chat = chatDic[targetID] {
            chat.lastMessageTime = data.time
            chat.lastMessageData = getString(data: data)
            if currentChat != chat {
                chat.unreadCount += 1
            }
            do {
                let on = [ChatListModel.Properties.lastMessageTime,
                          ChatListModel.Properties.lastMessageData,
                          ChatListModel.Properties.unreadCount]
                try db.update(table: chat_list, on: on, with: chat, where:ChatListModel.Properties.targetID == targetID , orderBy: nil, limit: nil, offset: nil)
                
                updateUserInfo(userInfo: userInfo)
            } catch {}
            chatModel = chat
            
        } else {
            let chat = ChatListModel()
            chat.targetID = targetID
            chat.selfID = selfID
            chat.lastMessageTime = data.time
            chat.lastMessageData = getString(data: data)
            chat.unreadCount += 1
            do {
                try db.insert(objects: chat, intoTable: chat_list)
                try db.insert(objects: userInfo, intoTable: user_info)
            } catch {}
            chatDic[targetID] = chat
            chatModel = chat
        }
        
        if let index = chatList.index(of: chatModel) {
            chatList.remove(at: index)
        }
        
        if chatList.count > 0 {
            for chat in chatList {
                if chat.lastMessageTime < chatModel.lastMessageTime {
                    if let index = chatList.index(of: chat) {
                        chatList.insert(chatModel, at: index)
                    }
                    break
                }
            }
        } else {
            chatList.append(chatModel)
        }
    }
    
    
    class func updateChat(chat: ChatListModel)  {
        Default.updateChat(chat: chat)
    }
    func updateChat(chat: ChatListModel)  {
        do {
            let on = ChatListModel.Properties.unreadCount
            try db.update(table: chat_list, on: on, with: chat, where:ChatListModel.Properties.targetID == chat.targetID , orderBy: nil, limit: nil, offset: nil)
        } catch {}
    }
    
    
    class func getUserInfo(targetID: String) -> UserInfo? {
        return Default.getUserInfo(targetID: targetID)
    }
    func getUserInfo(targetID: String) -> UserInfo? {
        if let user = userInfoDic[targetID] {
            print(user.avatar)
            return user
        }
        return getUserInfoWithDB(targetID: targetID)
    }
    
    func getUserInfoWithDB(targetID: String) -> UserInfo? {
        do {
            if let user: UserInfoModel = try db.getObject(on: UserInfoModel.Properties.all, fromTable: user_info, where: UserInfoModel.Properties.id == targetID, orderBy: nil, offset: nil) {
                var userInfo = UserInfo()
                userInfo.id = user.id
                userInfo.name = user.name
                userInfo.avatar = user.avatar
                userInfoDic[targetID] = userInfo
                print(userInfo.avatar)
                return userInfo
            }
        } catch {}
        print("user nil")
        return nil
    }
    
    
    func updateUserInfo(userInfo: UserInfoModel)  {
        if getUserInfoWithDB(targetID: userInfo.id) != nil {
            do {
                let uion = [UserInfoModel.Properties.name,
                            UserInfoModel.Properties.avatar]
                try db.update(table: user_info, on: uion, with: userInfo, where: UserInfoModel.Properties.id == userInfo.id, orderBy: nil, limit: nil, offset: nil)
            } catch {}
        } else {
            do {
                try db.insert(objects: userInfo, intoTable: user_info)
            } catch {}
        }
    }
    
    class func updateUserInfo(userInfo: UserInfoModel)  {
        Default.updateUserInfo(userInfo: userInfo)
    }
    
    func removeChat(index: Int) {
        let chat = chatList.remove(at: index)
        chatDic.removeValue(forKey: chat.targetID)
        
        do {
            try db.delete(fromTable: chat_list, where: ChatListModel.Properties.targetID == chat.targetID, orderBy: nil, limit: nil, offset: nil)
            try db.drop(table: DBManager.getTableName(targetID: chat.targetID))
        } catch {}
    }
    
    class func removeChat(index: Int) {
        Default.removeChat(index: index)
    }
    
    // MARK: - Message
    class func insert<Object: TableCodable>(model: Object, targetID: String) {
        do {
            if try Default.db.isTableExists(getTableName(targetID: targetID)) == false {
                do {
                    try Default.db.create(table: getTableName(targetID: targetID), of: Object.self)
                } catch {}
            }
        } catch {}
        
        
        do {
            try Default.db.insert(objects: model, intoTable: getTableName(targetID: targetID))
        } catch {}
        print(Default.db.path)
    }
    
    class func insertBaseModel(model: MessageBaseModel, targetID: String) -> MessageBaseModel {
        let table = getTableName(targetID: targetID)
        do {
            if try Default.db.isTableExists(table) == false {
                do {
                    try Default.db.create(table: table, of: MessageBaseModel.self)
                } catch {}
            }
        } catch {}
        
        
        do {
            try Default.db.insert(objects: model, intoTable: getTableName(targetID: targetID))
            
            let whereS = MessageBaseModel.Properties.time == model.time

            if let baseModel: MessageBaseModel = try Default.db.getObject(on: MessageBaseModel.Properties.all, fromTable: table, where: whereS, orderBy: nil, offset: nil) {
                return baseModel
            }
            
        } catch {}
        print(Default.db.path)
        return model
    }
    
    class func update(model: MessageModel?) {
        if model == nil {return}
        do {
            var whereS = MessageBaseModel.Properties.time == model!.messageBaseModel.time
            if model?.messageBaseModel.MesLocalID != nil {
                whereS = MessageBaseModel.Properties.MesLocalID == model!.messageBaseModel.MesLocalID!
            }
            let on = [MessageBaseModel.Properties.data,
                      MessageBaseModel.Properties.status,
                      MessageBaseModel.Properties.type,
                      MessageBaseModel.Properties.MsgID,
                      MessageBaseModel.Properties.time]
            
            try Default.db.update(table: model!.tableName, on: on, with: model!.messageBaseModel, where:whereS , orderBy: nil, limit: nil, offset: nil)
        } catch {}
    }
    
    class func delete(model: MessageModel?) {
        if model == nil {return}
        do {
            var whereS = MessageBaseModel.Properties.time == model!.messageBaseModel.time
            if model?.messageBaseModel.MesLocalID != nil {
                whereS = MessageBaseModel.Properties.MesLocalID == model!.messageBaseModel.MesLocalID!
            }
            try Default.db.delete(fromTable: model!.tableName, where: whereS, orderBy: nil, limit: nil, offset: nil)
        } catch {}
    }
    
    
    class func getObjects<Object: TableCodable>(targetID: String, startID: Int) -> [Object]? {
        print("start iD \(startID), \(message_limit)")
        do {
            return try Default.db.getObjects(on: Object.Properties.all, fromTable: getTableName(targetID: targetID), where: nil, orderBy: nil, limit: message_limit, offset: startID)
        } catch {
            return nil
        }
    }
    
    class func updateAllBaseModalRead(targetID: String) {
        do {
            let baseModel = MessageBaseModel()
            baseModel.status = MessageData.MessageStatus.read.rawValue

            let whereS = MessageBaseModel.Properties.status == MessageData.MessageStatus.unread.rawValue
            
            try Default.db.update(table: getTableName(targetID: targetID), on: MessageBaseModel.Properties.status, with: baseModel, where: whereS, orderBy: nil, limit: nil, offset: nil)
            print(Default.db.path)
        } catch {}
    }
    class func updateBaseModal(message: Message) {
        do {
            let baseModel = MessageBaseModel()
            baseModel.type = MessageStatus.Normal.rawValue
            
            try Default.db.update(table: getTableName(targetID: message.receiveData.targetID), on: MessageBaseModel.Properties.status, with: baseModel, where: MessageBaseModel.Properties.time == message.receiveData.sendTime, orderBy: nil, limit: nil, offset: nil)
        } catch {}
    }
    
    class func getCount(targetID: String) -> Int {
        do {
            let t = try Default.db.getTable(named: getTableName(targetID: targetID), of: MessageBaseModel.self)
            do {
                let c = try t?.getRows(on: MessageBaseModel.Properties.MesLocalID)
                return c?.count ?? 0
            }
        } catch {}
        return 0
    }
    
    class func getTableName(targetID: String) -> String {
        return "tb_" + targetID
    }
}



