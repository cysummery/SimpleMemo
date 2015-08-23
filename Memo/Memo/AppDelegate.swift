//
//  AppDelegate.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        prepareWindow()
        
        setEverNoteKey()
        
        loadDefaultMemos()
        
        return true
    }
    
    private func loadDefaultMemos(){
        
        let oldVersion = NSUserDefaults.standardUserDefaults().objectForKey("MemoVersion") as? String
        
        if oldVersion != nil {
            return
        }
        
        let dict = NSBundle.mainBundle().infoDictionary!
        let version = dict["CFBundleShortVersionString"] as! String
        
        NSUserDefaults.standardUserDefaults().setObject(version, forKey: "MemoVersion")
        
        let path = NSBundle.mainBundle().pathForResource("DefaultMemos", ofType: "plist")
        
        if path == nil {
            return
        }
        let memos = NSArray(contentsOfFile: path!) as! [String]
        
        for memoText in memos {
            
            let memo = CoreDataStack.shardedCoredataStack.creatMemo()
            
            memo.text = memoText
            
            CoreDataStack.shardedCoredataStack.saveContext()
            
        }
        
    }
    
    // 设置印象笔记
    private func setEverNoteKey(){
        
//        let SANDBOX_HOST = ENSessionHostSandbox
        let CONSUMER_KEY = "your key"
        let CONSUMER_SECRET = "your secret"
        
        ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET, optionalHost: nil)
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        let didHandle = ENSession.sharedSession().handleOpenURL(url)
        
        return didHandle
    }
    
    
    private func prepareWindow(){
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        window?.rootViewController = UINavigationController(rootViewController: MemoListViewController())
        window?.makeKeyAndVisible()
        
    }
    
    private func prepareNavigation(){
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 18/255.0, green: 136/255.0, blue: 97/255.0, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        CoreDataStack.shardedCoredataStack.fetchAndSaveNewMemos()
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //        self.saveContext()
        CoreDataStack.shardedCoredataStack.saveContext()
    }
    
    
}

