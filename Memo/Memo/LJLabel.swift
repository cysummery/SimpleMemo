//
//  LJLabel.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//  自定义UILabel, 实现文字据顶部显示

import UIKit

class LJLabel: UILabel {
    /// 文字显示位置
    enum VerticalAlignment: Int {
        
        case Top = 0
        case Middle = 1 // default
        case Bottom = 2
    }
    
    var verticalAlignment: VerticalAlignment?  {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalAlignment = .Middle
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        var textRect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        
        switch verticalAlignment! {
            
        case .Top:
            textRect.origin.y = bounds.origin.y
        case .Bottom:
            textRect.origin.y = bounds.origin.y + bounds.height - textRect.height
        case .Middle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
            
        }
        return textRect
        
    }
    
    override func drawTextInRect(rect: CGRect) {
        let actualRect = textRectForBounds(rect, limitedToNumberOfLines: numberOfLines)
        
        super.drawTextInRect(actualRect)
    }

    

}
