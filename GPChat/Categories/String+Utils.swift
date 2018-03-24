//
//  String+Utils.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/10/25.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return evaluate(format: "SELF MATCHES %@", args: emailRegex)
    }
    
    func isMobilePhone() -> Bool {
        if self.utf16.count != 11 {
            return false
        }
        
        /**
         * 移动号段正则表达式
         */
        let CM_NUM = "^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$"
        /**
         * 联通号段正则表达式
         */
        let CU_NUM = "^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$"
        /**
         * 电信号段正则表达式
         */
        let CT_NUM = "^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$"
        
        let format = "SELF MATCHES %@"
        
        let isMatch1 = evaluate(format: format, args: CM_NUM)
        let isMatch2 = evaluate(format: format, args: CU_NUM)
        let isMatch3 = evaluate(format: format, args: CT_NUM)
        return isMatch1 || isMatch2 || isMatch3
    }
    
    func isChinaIDCard() -> Bool {
        let chinaIDCardRegex = "^(\\d{14}|^\\d{17})(\\d|X|x)$"
        return evaluate(format: "SELF MATCHES %@", args: chinaIDCardRegex)
    }
    
    func evaluate(format: String, args: CVarArg) -> Bool {
        let pre = NSPredicate.init(format: format, args)
        return pre.evaluate(with:self)
    }
    
    func intValue() -> Int {
        return (self as NSString).integerValue
    }
}
