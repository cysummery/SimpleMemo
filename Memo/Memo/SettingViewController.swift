//
//  SettingViewController.swift
//  Memo
//
//  Created by  李俊 on 15/8/7.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var loginEvernote: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginEvernote.text = ENSession.sharedSession().isAuthenticated ? ENSession.sharedSession().userDisplayName : "登录印象笔记"
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            if ENSession.sharedSession().isAuthenticated {
                
                let alert = UIAlertController(title: "退出印象笔记?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "退出", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                    
                    ENSession.sharedSession().unauthenticate()
                    self.loginEvernote.text = "登录印象笔记"
                    
                    
                }))
                
                presentViewController(alert, animated: true, completion: nil)
                
            } else {
                
                ENSession.sharedSession().authenticateWithViewController(self, preferRegistration: false, completion: { (error: NSError?) -> Void in
                    
                    if error == nil {
                        
                        self.loginEvernote.text = ENSession.sharedSession().userDisplayName
                    }
                    
                })
            }
            
        }
        
    }
}

