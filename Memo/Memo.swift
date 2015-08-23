//
//  Memo.swift
//  Memo
//
//  Created by  李俊 on 15/8/7.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import Foundation
import CoreData

class Memo: NSManagedObject {

    @NSManaged var changeDate: NSDate
    @NSManaged var text: String
    @NSManaged var noteRef: ENNoteRef?
    @NSManaged var isUpload: NSNumber
    
}

extension Memo {
    
    /// 上传便签到印象笔记
    func uploadToEvernote() {
        
        let note = ENNote()
        
        note.title = self.text.fetchTitle()
        
        let noteContent = ENNoteContent(string: self.text)
        
        note.content = noteContent
        
        
        if noteRef == nil {
            
            ENSession.sharedSession().uploadNote(note, notebook: nil, completion: { (noteRef, error) -> Void in
                
                if noteRef != nil {
                    self.noteRef = noteRef
                    self.isUpload = true
                    CoreDataStack.shardedCoredataStack.saveContext()
                }
            })
            
        }else{
            
            ENSession.sharedSession().uploadNote(note, policy: ENSessionUploadPolicy.ReplaceOrCreate, toNotebook: nil, orReplaceNote: noteRef, progress: nil, completion: { (noteRef, error) -> Void in
                
                
                if noteRef != nil {
                    self.noteRef = noteRef
                    self.isUpload = true
                    CoreDataStack.shardedCoredataStack.saveContext()
                }
                
            })
            
        }
    }
    
    /// 删除印象笔记中的便签
    func deleteFromEvernote(){
        if noteRef == nil || !ENSession.sharedSession().isAuthenticated {
            return
        }
        
        ENSession.sharedSession().deleteNote(noteRef!, completion: { (error) -> Void in
            
            if error != nil {
                println(error)
            }
            
        })
    }
}