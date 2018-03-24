//
//  NetworkManager.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/19.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

public class NetworkManager {
    public static let Default = NetworkManager()
    var hostReachability = Reachability()
    let interbetReachability = Reachability.forInternetConnection()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        //
        //        hostReachability = Reachability.init(hostName: "www.baidu.com")
        //        hostReachability.startNotifier()
        //        updateInterface(reach: hostReachability)
        
        interbetReachability?.startNotifier()
        updateInterface(reach: interbetReachability!)
    }
    
    class func networkStatusHandle(networkStatusHandle ns: @escaping (Bool) -> Void) {
        Default.networkStatusHandle = ns
        Default.updateInterface(reach: Default.interbetReachability!)
    }
    
    @objc func reachabilityChanged(note: Notification)  {
        if let reach = note.object as? Reachability {
            updateInterface(reach: reach)
        }
    }
    
    
    var networkStatusHandle: ((Bool) -> Void)?
    func updateInterface(reach: Reachability)  {
        
        if reach == interbetReachability {
            let status = reach.currentReachabilityStatus()
            switch status {
//            case NotReachable:
//                networkStatusHandle?(false)

//                print("not network")
            case ReachableViaWiFi:
                networkStatusHandle?(true)

                print("wifi")
            case ReachableViaWWAN:
                networkStatusHandle?(true)

                print("2G/3G/4G")
            default:
                networkStatusHandle?(false)
                print("none")
            }
        }
        
        if reach == hostReachability && reach.currentReachabilityStatus() == ReachableViaWWAN {
            
//            if reach.connectionRequired() {
//                print("connect")
//            } else {
//                print("not connect")
//            }
        }
    }
    
}
