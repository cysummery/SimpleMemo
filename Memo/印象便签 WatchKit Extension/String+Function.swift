//
//  String+Function.swift
//  Memo
//
//  Created by  李俊 on 15/8/9.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import Foundation

extension String {
    
    func deleteBlankLine() -> String {
        
        let newText = stringByReplacingOccurrencesOfString("\n\n", withString: "\n")
        
        if newText == self {
            
            return newText
        } else {
            
            return newText.deleteBlankLine()
        }
        
    }
    
    
}