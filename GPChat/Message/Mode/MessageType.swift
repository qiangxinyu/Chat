//
//  MessageType.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/30.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation



enum MessageCellType: String {
    case Date = "cell_key_date"
    case Sender = "cell_key_sender"
    case Receive = "cell_key_receive"
}


enum MessageStatus: Int {
    case Sending = 1
    case SendFailed = 2
    case Normal = 0
}
