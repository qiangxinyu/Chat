//
//  AppDelegate.swift
//  TE
//
//  Created by 强新宇 on 2018/3/24.
//  Copyright © 2018年 强新宇. All rights reserved.
//

import UIKit
import UserNotifications

var token = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                
            }
        } else { //iOS8,iOS9注册通知
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    
    private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void){
        let userInfo = notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        completionHandler([.sound,.alert])
        
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    private func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        let userInfo = response.notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        completionHandler()
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("收到新消息Active\(userInfo)")
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
        }else{
            // 代表从后台接受消息后进入app
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler(.newData)
        
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let DT = deviceToken as NSData
        let DTS = DT.description.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
        
        token = DTS
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

