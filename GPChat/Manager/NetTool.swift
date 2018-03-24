//
//  XYNetTool.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/10/25.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation

import Qiniu

open class NetTool {
    @discardableResult
    public class func Download(url: String) -> RequestResult {
        let result = RequestResult()
        
        if let _url = URL(string: url) {
            let dataTask = URLSession.shared.dataTask(with: _url) {
                data, response, error in
                if error == nil {
                    result.successHandler?(data)
                } else {
                    result.errorHandler?(error)
                }
            }
            dataTask.resume()
        }
        
        return result
    }
    
    
    @discardableResult
    public class func GetQNToken() -> RequestResult {
        let result = RequestResult()
        let url = "http://60.205.231.127:234/gettoken"
        if let _url = URL(string: url) {
            let dataTask = URLSession.shared.dataTask(with: _url) {
                data, response, error in
                if error == nil {
                    result.successHandler?(data)
                } else {
                    result.errorHandler?(error)
                }
            }
            dataTask.resume()
        }
        return result
    }
    
    // MARK: - RequestResult
    
    public class RequestResult {
        
        init() {}
        
        var successHandler: ((Any?) -> Void)?
        var failureHandler: ((Any) -> Void)?
        var errorHandler: ((Error?) -> Void)?
        
        @discardableResult
        func success(completionHandler:  @escaping (Any) -> Void) -> Self {
            successHandler = completionHandler
            return self
        }
        
        @discardableResult
        func failure(completionHandler:  @escaping (Any) -> Void) -> Self {
            failureHandler = completionHandler
            return self
        }
        
        @discardableResult
        func error(completionHandler:  @escaping (Error?) -> Void) -> Self {
            errorHandler = completionHandler
            return self
        }
    }

}



// MARK: - Request

