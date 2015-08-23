//
//  MemoDetailController.swift
//  Memo
//
//  Created by  李俊 on 15/8/8.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import WatchKit
import Foundation


class MemoDetailController: WKInterfaceController {

    @IBOutlet weak var memoDetailLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let memo = context as! String
        
        memoDetailLabel.setText(memo)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
}
