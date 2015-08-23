//
//  MemoGlanceController.swift
//  Memo
//
//  Created by  李俊 on 15/8/8.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import WatchKit
import Foundation


class MemoGlanceController: WKInterfaceController {

    @IBOutlet weak var lastestMemo: WKInterfaceLabel!
    
    var memo:[String: AnyObject]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        loadData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        loadData()
    }
    
    private func loadData(){
        
        let sharedDefaults = NSUserDefaults(suiteName: "group.likumb.com.Memo")
        
        let data =  sharedDefaults?.objectForKey("WatchMemo") as? [[String: AnyObject]]
        
        if let memoList = data {
            
            memo = memoList[0]
            
            let content = memo!["text"] as! String
            
            let text = content.stringByReplacingOccurrencesOfString("\n", withString: "  ")
            
            lastestMemo.setText(text)
            
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
