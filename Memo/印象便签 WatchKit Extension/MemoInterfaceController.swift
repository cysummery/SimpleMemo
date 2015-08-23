//
//  MemoInterfaceController.swift
//  Memo
//
//  Created by  李俊 on 15/8/8.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import WatchKit
import Foundation


class MemoInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var memoTable: WKInterfaceTable!
    var newMemo = [String: AnyObject]()
    var memos = [[String: AnyObject]]()
    var isPush = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        loadData()
        setTable()
    }
    @IBAction func addMemo() {
        
        
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: .Plain, completion: { (content) -> Void in
            
            if content == nil {
                return
            }
            
            if let text = content[0] as? String {
            
                self.saveNewMemo(text)
                
                self.setTable()
               
            }
        })
        
    }
    
    private func saveNewMemo(content: String){
        
        var memo = [String: AnyObject]()
        memo["text"] = content
        memo["changeDate"] = NSDate()
        
        memos.insert(memo, atIndex: 0)
        
        // 将新笔记共享给iPhone
        let sharedDefaults = NSUserDefaults(suiteName: "group.likumb.com.Memo")
        
        var results = sharedDefaults?.objectForKey("MemoContent") as? [AnyObject]
        
        if results != nil {
            
            results!.append(memo)
            
            sharedDefaults?.setObject(results, forKey: "MemoContent")
        } else{
            
            var contents = [memo]
            
            sharedDefaults?.setObject(contents, forKey: "MemoContent")
            
        }
        
        // 共享apple watch共享数据池里的数据
        sharedDefaults?.setObject(memos, forKey: "WatchMemo")
        
        sharedDefaults!.synchronize()
    }

    
    private func setTable(){
        
        memoTable.setNumberOfRows(memos.count, withRowType: "memoRow")
        
        for (index, memo) in enumerate(memos) {
            
            let controller = memoTable.rowControllerAtIndex(index) as! MemoRowController
            
            let text = memo["text"] as! String
            let memoText = text.deleteBlankLine()
            controller.memoLabel.setText(memoText)
            
        }
        
    }
    
    private func loadData(){
        
        let sharedDefaults = NSUserDefaults(suiteName: "group.likumb.com.Memo")
            
        let data =  sharedDefaults?.objectForKey("WatchMemo") as? [[String: AnyObject]]
        
        if let memoList = data {
            
            memos = memoList
        }
        
    }

    override func willActivate() {
        
        super.willActivate()
        
        if !isPush {
            
            loadData()
            setTable()
        }
        
        isPush = false
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "memoDetail" {
        isPush = true
        
       let memo =  memos[rowIndex]
        
        return (memo["text"] as! String)
        }
        
//        presentTextInputControllerWithSuggestions
        
        
        return nil
    }


}
