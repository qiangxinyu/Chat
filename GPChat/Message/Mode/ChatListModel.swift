//
//  ChatListModel.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/22.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import WCDBSwift


import WCDBSwift

class ChatListModel: NSObject, TableCodable {
    required override init() {
        print("-----")
    }

    var lastMessageTime: UInt64 = 0 {
        didSet {
            lastMessageTimeString = Date.getTimeString(timeInterval: lastMessageTime)
        }
    }
    
    var lastMessageTimeString: String = ""
    
    var lastMessageData: String = ""
    var unreadCount: Int = 0
    
    var targetID: String = ""
    var selfID: String = ""
    var localID: Int? = nil
    
    func update()  {
        DBManager.updateChat(chat: self)
    }
    
    
    enum CodingKeys: String, CodingTableKey {
        
        typealias Root = ChatListModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case lastMessageData
        case unreadCount

        case lastMessageTime
        case targetID
        case selfID
        
        
        case localID
        
        static var columnConstraintBindings: [CodingKeys:ColumnConstraintBinding]? {
            return [
                .localID:ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }

}
