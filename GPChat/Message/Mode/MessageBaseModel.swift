//
//  MessageBaseModel.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/11.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import WCDBSwift

extension MessageData {
    init(model: MessageBaseModel) {
        id = model.MsgID
        type = MessageData.MessageDataType.init(rawValue: model.type)!
        data = model.data
        time = model.time
        imgWidth = model.imgWidth
        imgHeight = model.imgHeight
        voiceTime = model.voiceTime
        targetID = model.targetID
        status = MessageData.MessageStatus.init(rawValue: model.status)!
    }
}

class MessageBaseModel: TableCodable {
    required init() {}
    
    @discardableResult
    init(msg: MessageData) {
        
        let msgData = msg
        
        MsgID = msgData.id
        type = msgData.type.rawValue
        cellType = MessageCellType.Receive.rawValue
        data = msgData.data
        time = msgData.time
        
        status = msgData.status.rawValue
        
        imgHeight = msgData.imgHeight
        imgWidth = msgData.imgWidth
        voiceTime = msgData.voiceTime
        targetID = msgData.userInfo.id
    }
    
    
    
    var MsgID: String = ""
    var MesLocalID: Int? = nil
    var cellType: String = ""
    var type: Int = 0
    var data: String = ""
    var status: Int = 0
    var time: UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
    var imgHeight: UInt32 = 0
    var imgWidth: UInt32 = 0
    var voiceTime: UInt32 = 0
    var targetID: String = ""
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MessageBaseModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case MesLocalID
        case cellType
        case targetID
        
        case type
        case data
        case status
        case MsgID
        
        case time
        case imgHeight
        case imgWidth
        case voiceTime
        static var columnConstraintBindings: [CodingKeys:ColumnConstraintBinding]? {
            return [
                .MesLocalID:ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
    
    @discardableResult
    func insert(targetID: String) -> MessageBaseModel {
        return DBManager.insertBaseModel(model: self, targetID: targetID)
    }
    
    
}
