//
//  MemoCell.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class MemoCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var deleteMemo: ((memo: Memo) -> ())?
    
    var memo: Memo? {
        didSet{
            
            contentLabel.text = memo!.text
            contentLabel.preferredMaxLayoutWidth = itemWidth - 2 * margin
            
        }
    }
    
    
    private let contentLabel: LJLabel = {
        
        let label = LJLabel()
        
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = itemWidth - 2 * margin
        label.font = UIFont.systemFontOfSize(15)
//        label.textColor = UIColor.darkGrayColor()
        label.verticalAlignment = .Top
        
        label.sizeToFit()
        
        return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        setUI()
        
        // 设置阴影
        layer.shadowOffset = CGSize(width: 0, height: 1);
        layer.shadowOpacity = 0.2;
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI(){
        
        contentView.addSubview(contentLabel)
        
        contentLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 5))
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 5))
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -5))
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -5))
        addGestureRecognizer()
        
    }
    
    private var getsureRecognizer: UIGestureRecognizer?
    private func addGestureRecognizer() {
        
        getsureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress")
        
        getsureRecognizer!.delegate = self
        
        contentView.addGestureRecognizer(getsureRecognizer!)
        
    }
    
    
    func longPress(){
        
        // 添加一个判断,防止触发两次
        if getsureRecognizer?.state == .Began{
            
            deleteMemo?(memo: memo!)
        }
        
    }
    
    override func prepareForReuse() {
        deleteMemo = nil
    }
}

