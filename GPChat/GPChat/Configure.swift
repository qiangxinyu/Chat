//
//  Configure.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/10/25.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation

var selfID = "1"
var selfToken = "1"

var selfName = "qxy"
var selfAvatar = "https://avatars3.githubusercontent.com/u/13347582?s=460&v=4"


let App_ID = "goopin"

let kNotificationCenter = NotificationCenter.default
let kWindow = UIApplication.shared.keyWindow

let kSystemVersion = (UIDevice.current.systemVersion as NSString).floatValue

let kScreenBounds = UIScreen.main.bounds
let kScreenSize = kScreenBounds.size
let kScreenWidth = kScreenSize.width
let kScreenHeight = kScreenSize.height

let IS_iPhoneX = kScreenHeight == 812
let naviBarTop: CGFloat = IS_iPhoneX ? 20 : 0
let naviBarHeight: CGFloat = IS_iPhoneX ? 88 : 64

let IS_iOS11 = kSystemVersion >= 11.0

func print(_ args: Any...) {
    #if DEBUG
        print("------------------------------ \\/ ------------------------------", separator: "", terminator: "\n")
        print(args, separator: "--->>>", terminator: "\n")
        print("------------------------------ /\\ ------------------------------", separator: "", terminator: "\n")
    #endif
}
