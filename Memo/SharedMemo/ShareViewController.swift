//
//  ShareViewController.swift
//  ShareMemo
//
//  Created by  李俊 on 15/8/6.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool{
        
        if contentText.isEmpty {
            
            return false
        }
        
        return true
        
    }
    
    override func didSelectPost() {
        super.didSelectPost()
        saveContent(contentText)
        
    }
    
    private func saveContent(content: String){
        
        var memo = [String: AnyObject]()
        memo["text"] = content
        memo["changeDate"] = NSDate()
        
        let sharedDefaults = NSUserDefaults(suiteName: "group.likumb.com.Memo")
        
        var results = sharedDefaults?.objectForKey("MemoContent") as? [AnyObject]
        
        if results != nil {
            
            results!.append(memo)
            
            sharedDefaults?.setObject(results, forKey: "MemoContent")
        } else{
            
            var contents = [memo]
            
            sharedDefaults?.setObject(contents, forKey: "MemoContent")
            
        }
        
        sharedDefaults!.synchronize()
    }
    
}
