//
//  UserInfoModel.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/22.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import WCDBSwift

class UserInfoModel: TableCodable {
    required init() {}
    
    class func conversion(userInfo: UserInfo) -> UserInfoModel {
        let ui = UserInfoModel()
        ui.id = userInfo.id
        ui.name = userInfo.name
        ui.avatar = userInfo.avatar
        return ui
    }
    
    class func conversion1(userInfo: UserInfoModel) -> UserInfo {
        var ui = UserInfo()
        ui.id = userInfo.id
        ui.name = userInfo.name
        ui.avatar = userInfo.avatar
        return ui
    }
    
    var localID: Int? = nil

    var id: String = ""
    var name: String = ""
    var avatar: String = ""
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = UserInfoModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case id
        case name
        case avatar

        case localID
        
        static var columnConstraintBindings: [CodingKeys:ColumnConstraintBinding]? {
            return [
                .localID:ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
}
