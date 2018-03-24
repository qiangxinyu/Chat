//
//  Bundle+Default.swift
//  GPChat
//
//  Created by 强新宇 on 2018/1/3.
//  Copyright © 2018年 强新宇. All rights reserved.
//

import Foundation

extension Bundle {
    class func Default() -> Bundle {
        return Bundle.init(for: RootViewController.self)
    }
}
