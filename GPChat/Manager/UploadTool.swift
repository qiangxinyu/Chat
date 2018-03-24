//
//  UpdateTool.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/15.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import Qiniu

public class UploadTool: NSObject {
    public static let Default = UploadTool()
    public let manager = QNUploadManager()
    
    let rootURL = "http://7xt5gl.com1.z0.glb.clouddn.com/"
    
    fileprivate override init() {}
    
    public class func getFileURL(suffix: String) -> String {
        return Default.rootURL + "\(Date().timeIntervalSince1970)." + suffix
    }
    
    public class func getQNToken(handle: @escaping (String) -> Void) {
        let qntoken_key = "qntoken_key"
        let qntoken_time_key = "qntoken_time_key"
        
        if let time = UserDefaults.standard.value(forKey: qntoken_time_key) as? TimeInterval,
            Date().timeIntervalSince1970 - time < TimeInterval(12 * 3600),
            let token = UserDefaults.standard.value(forKey: qntoken_key) as? String {
            handle(token)
        } else {
            NetTool.GetQNToken()
                .success(completionHandler: { (json) in
                    print(json)
                    if let data = json as? Data {
                        do {
                            let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                            if let tokenDic = dic as? [String: String],
                               let token = tokenDic["token"] {
                                handle(token)
                            }
                        } catch {
                            print("JSONSerialization qn token -> \(error)")
                        }
                        
                    }
                })
                .error(completionHandler: { (error) in
                    print(error)
                })
        }
        

    }
    
    public typealias ProgressHandle = (Float) -> Void
    public typealias FinishHandle = (String) -> Void
    public typealias FailedHandle = () -> Void

    
    public func upload(key: String, data: Data, progress: ProgressHandle?, finish: @escaping FinishHandle,fail: FailedHandle?) -> String {
        let option = QNUploadOption.init(progressHandler: { (s,d) in
            print(s ?? "s",d)
            progress?(d)
        })
        
        UploadTool.getQNToken {[weak self] token in
            self?.manager?.put(data, key: key, token: token, complete: { (info,_,_) in
                print("upload finish")
                if (info?.isOK)! {
                    finish(self!.rootURL + key)
                } else {
                    fail?()
                }
                }, option: option)
        }
        
        return rootURL + key
    }
    
    public func uploadImage(data: Data, progress: ProgressHandle?, finish: @escaping FinishHandle,fail: FailedHandle?) -> String {
        let key = "\(Date().timeIntervalSince1970).png"
        return upload(key: key, data: data, progress: progress, finish: finish, fail: fail)
    }
    
    public class func uploadImage(data: Data, progress:  ProgressHandle?, finish: @escaping FinishHandle,fail: FailedHandle?) -> String {
        return Default.uploadImage(data: data, progress: progress, finish: finish, fail: fail)
    }
    
    
    public func uploadVoice(data: Data, progress: ProgressHandle?, finish: @escaping FinishHandle,fail: FailedHandle?) -> String {
        let key = "\(Date().timeIntervalSince1970).mp3"
        return upload(key: key, data: data, progress: progress, finish: finish, fail: fail)
    }
    @discardableResult
    public class func uploadVoice(data: Data, progress:  ProgressHandle?, finish: @escaping FinishHandle,fail: FailedHandle?) -> String {
        return Default.uploadVoice(data: data, progress: progress, finish: finish, fail: fail)
    }
}
