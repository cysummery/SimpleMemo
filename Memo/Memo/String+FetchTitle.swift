//
//  String+FetchTitle.swift
//  Memo
//
//  Created by  李俊 on 15/8/7.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import Foundation

extension String {
    
    func fetchTitle() -> String{
        
        var title: String
        
        let range = self.rangeOfString("\n")
        
        if range != nil {
            
            title = self.substringToIndex(range!.startIndex)
            
            let nstitle: NSString = title
            if nstitle.length > 0 {
                
                return title
            }
            
        }
        
        let text: NSString = self
        
        if text.length > 15 {
            
            title = text.substringToIndex(15)
        } else {
            title = self
        }
        
        return title
        
    }

    
    
}