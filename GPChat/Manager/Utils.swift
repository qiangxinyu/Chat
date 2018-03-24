//
//  Utils.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/10/25.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation

// MARK: - Alert

public func alert(message: String) {
    alert(message: message, sureText: "确定", sureBlock: nil, cancleText: nil, cancleBlock: nil, viewController: nil)
}
public func alert(message: String,viewController: UIViewController) {
    alert(message: message, sureText: "确定", sureBlock: nil, cancleText: nil, cancleBlock: nil, viewController: viewController)
}

public func alert(message: String, sureText: String?, sureBlock: ((UIAlertAction) -> Void)?) {
    alert(message: message, sureText: sureText, sureBlock: sureBlock, cancleText: nil, cancleBlock: nil, viewController: nil)
}
public func alert(message: String, sureText: String?, sureBlock: ((UIAlertAction) -> Void)?, viewController: UIViewController) {
    alert(message: message, sureText: sureText, sureBlock: sureBlock, cancleText: nil, cancleBlock: nil, viewController: viewController)
}


public func alert(message: String,
           sureText: String?,
           sureBlock: ((UIAlertAction) -> Void)?,
           cancleText:String?,
           cancleBlock:((UIAlertAction) -> Void)?,
           viewController: UIViewController?)
{
    var viewController = viewController
    if viewController == nil {
        viewController = kWindow?.rootViewController
    }
    
    let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
    if cancleText != nil {
        alert.addAction(UIAlertAction.init(title: cancleText, style: .default, handler: cancleBlock))
    }
    alert.addAction(UIAlertAction.init(title: sureText, style: .destructive, handler: sureBlock))
    DispatchQueue.main.async {
        viewController?.present(alert, animated: true, completion: nil)
    }
}


