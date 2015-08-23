//
//  MemoViewController.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit
import CoreData

class MemoViewController: UIViewController, UITextViewDelegate {
    
    let textView = UITextView()
    var memo: Memo?
    var textViewBottomConstraint: NSLayoutConstraint?
    var sharedItem: UIBarButtonItem!
    
    var isTextChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTextView()
        textViewAttrubt()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeLayOut:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - 监听键盘的改变
    func changeLayOut(notification:NSNotification){
        
        let userInfo :[NSObject:AnyObject] = notification.userInfo!
        
        let userDic = userInfo as NSDictionary
        
        let keyboarFrame: AnyObject? = userDic.valueForKey(UIKeyboardFrameEndUserInfoKey)
        
        let frame = keyboarFrame?.CGRectValue()
        
        let keyboardY = frame?.origin.y

        textViewBottomConstraint!.constant = -(view.bounds.size.height - keyboardY! + 5)
        
    }

    // MARK: - 设置视图控件
    private func setUI(){
        
        view.backgroundColor = UIColor.whiteColor()
        
        sharedItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "perpormShare:")
        
        navigationItem.rightBarButtonItem = sharedItem
        
        if memo == nil{
            
            title = "新便签"
            textView.becomeFirstResponder()
            sharedItem.enabled = false
            
        }else{
            textView.text = memo!.text
        }
        
    }
    
    /// 分享
    func perpormShare(barButton: UIBarButtonItem){
        
        let activityController = UIActivityViewController(activityItems: [textView.text], applicationActivities: nil)
        let drivce = UIDevice.currentDevice()
        
        let model = drivce.model
        
        if model == "iPhone Simulator" || model == "iPhone" || model == "iPod touch"{
            
             presentViewController(activityController, animated: true, completion: nil)
        }else {
            
            let popoverView =  UIPopoverController(contentViewController: activityController)
            
            popoverView.presentPopoverFromBarButtonItem(barButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
       
    }
    
    private func setTextView(){
        
        textView.delegate = self
        
        textView.layoutManager.allowsNonContiguousLayout = false
//        textView.bounces = false
        /*
        case None
        case OnDrag // dismisses the keyboard when a drag begins
        case Interactive // the keyboard follows the dragging touch off screen, and may be pulled upward again to cancel the dismiss
        */
        textView.keyboardDismissMode = .Interactive
        
        view.addSubview(textView)
        
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 5))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -5))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -5))
        let constraints = view.constraints()
        textViewBottomConstraint = constraints.last as? NSLayoutConstraint
    }
    
    private func textViewAttrubt(){
        
        let paregraphStyle = NSMutableParagraphStyle()
        paregraphStyle.lineSpacing = 5
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(16),NSParagraphStyleAttributeName: paregraphStyle]
        textView.typingAttributes = attributes
        textView.font = UIFont.systemFontOfSize(16)
    }
    

    // MARK: - 视图消失时,
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        if textView.text.isEmpty && memo != nil{
            
            memo!.deleteFromEvernote()
            CoreDataStack.shardedCoredataStack.managedObjectContext?.deleteObject(memo!)
        }
        
        CoreDataStack.shardedCoredataStack.saveContext()
    }
    
    // MARK: - 上传便签到印象笔记
    
    private func uploadMemoToEvernote(){
        
        if textView.text.isEmpty {
            
            return
        }
        
        memo?.uploadToEvernote()
        
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        println(scrollView.contentOffset.y)
//        
//    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(textView: UITextView){
       
        isTextChanged = true
        
        memo?.isUpload = false
        sharedItem.enabled = !textView.text.isEmpty
        
        memo = (memo == nil) ? CoreDataStack.shardedCoredataStack.creatMemo() : memo
        
        memo!.text = textView.text
        
        memo!.changeDate = NSDate()
        
        CoreDataStack.shardedCoredataStack.saveContext()
        
    }
    
}
