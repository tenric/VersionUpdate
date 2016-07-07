//
//  VersionUpdate.swift
//  Tenric
//
//  Created by Tenric on 16/7/5.
//  Copyright © 2016年 Tenric. All rights reserved.
//

import UIKit

struct AppChannel {
    
    var name: String = ""
    
    var infoUrl: String = ""
    
    var downloadUrl: String = ""
    
    var alertTitle: String = "有新版本了！"
    
    var alertMessage: String = "若您选择忽略此版本，仍可以随时升级至最新。"
}

public class VersionUpdate: NSObject, NSURLSessionDelegate{
    
    var session: NSURLSession!
    var channels = Dictionary<String,AppChannel>()
    
    public func addAppStoreChannelWithAppId(appId:String) {
        var appStoreChannel = AppChannel()
        appStoreChannel.name = "AppStore"
        appStoreChannel.infoUrl = "https://itunes.apple.com/cn/lookup?id=\(appId)"
        appStoreChannel.downloadUrl = "https://itunes.apple.com/cn/app/id/\(appId)"
        if let appName = VersionUpdate.appName() {
            appStoreChannel.alertTitle = "\(appName)有新版本了！"
        }
        appStoreChannel.alertMessage = "若您选择忽略此版本，仍可以随时到appstore升级至最新。"
        
        channels[appStoreChannel.name] = appStoreChannel
    }
    
    public func addFirChannelWithAppId(appId:String, token:String, downloadUrl:String) {
        var firChannel = AppChannel()
        firChannel.name = "Fir"
        firChannel.infoUrl = "http://api.fir.im/apps/latest/\(appId)?api_token=\(token)"
        firChannel.downloadUrl = downloadUrl
        if let appName = VersionUpdate.appName() {
            firChannel.alertTitle = "\(appName)有新版本了！"
        }
        firChannel.alertMessage = "若您选择忽略此版本，仍可以随时到\(downloadUrl)升级至最新。"
        
        channels[firChannel.name] = firChannel
    }
    
    public func checkUpdate() {
        
        let channelName = VersionUpdate.channelName()
        if (channelName == nil || channels[channelName!] == nil) {
            return
        }
        
        let channel = channels[channelName!]! as AppChannel
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 20
        self.session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        let url = NSURL(string: channel.infoUrl)
        
        let task = self.session.dataTaskWithURL(url!) { (data, response, error) in
            
            self.session.finishTasksAndInvalidate()
            
            if data == nil {
                return
            }
            
            if channel.name == "AppStore" {
                
                let jsonDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let results = jsonDic["results"] as? NSArray
                
                if results!.count > 0 {
                    
                    let infoDic = results![0]
                    
                    if let version = infoDic["version"] as? String {
                        self.handleRemoteVersion(version, channel: channel)
                    }
                }
            }
            else if(channel.name == "Fir") {
                let jsonDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary

                if let version = jsonDic["versionShort"] as? String {
                    self.handleRemoteVersion(version, channel: channel)
                }
            }
        }
        
        task.resume()
        
    }
    
    func handleRemoteVersion(version:String, channel:AppChannel) {
        
        if let currentVersion = VersionUpdate.localVersion() {
            
            let ret = version.compare(currentVersion)
            
            if ret == NSComparisonResult.OrderedAscending {
                print("服务器版本小于本地版本")
            }
            else if ret == NSComparisonResult.OrderedDescending {
                print("服务器版本大于本地版本")

                let alert = UIAlertController(title:channel.alertTitle, message:channel.alertMessage, preferredStyle:UIAlertControllerStyle.Alert)
                let actionUpdate = UIAlertAction(title:"立即更新", style:UIAlertActionStyle.Destructive, handler: {
                    (alertAction: UIAlertAction) -> () in
                    
                    UIApplication.sharedApplication().openURL(NSURL(string: channel.downloadUrl)!)
                })
                let actionCancel = UIAlertAction(title:"忽略此版本", style:UIAlertActionStyle.Cancel, handler:nil)
                alert.addAction(actionUpdate)
                alert.addAction(actionCancel)
                dispatch_async(dispatch_get_main_queue(), {
                    let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController
                    if let viewController = viewController {
                        viewController.presentViewController(alert, animated:true, completion:nil)
                    }
                })
            }
            else {
                print("服务器版本等于本地版本")
            }
            
        }
    }
    
    static func localVersion() -> String? {
        
        var version: String?
        
        let infoDic = NSBundle.mainBundle().infoDictionary
        if let infoDic = infoDic {
            version = infoDic["CFBundleShortVersionString"] as? String
        }
        
        return version
    }
    
    
    static func channelName() -> String? {
        
        var channelName: String?
        
        let infoDic = NSBundle.mainBundle().infoDictionary
        if let infoDic = infoDic {
            channelName = infoDic["Channel"] as? String
        }
        
        return channelName
        
    }
    
    static func appName() -> String? {
        
        var appName: String?
        
        let infoDic = NSBundle.mainBundle().infoDictionary
        if let infoDic = infoDic {
            appName = infoDic["CFBundleName"] as? String
        }
        
        return appName
    }

}
