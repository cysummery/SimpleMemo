//
//  MemoCollectionViewController.swift
//  Memo
//
//  Created by  李俊 on 15/8/8.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

var margin: CGFloat = 10
var itemWidth: CGFloat = 0

class MemoCollectionViewController: UICollectionViewController {

    let flowLayout = UICollectionViewFlowLayout()
    var totalLie: Int = 0
    var deviceModel = UIDevice.currentDevice().model
    
    init(){
        
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.alwaysBounceVertical = true
        totalLie = totalCorBystatusBarOrientation()
        
        itemWidth = (collectionView!.bounds.width - CGFloat(totalLie + 1) * margin) / CGFloat(totalLie)
        
       setFlowLayout()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "statusBarOrientationChange:", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    
    }
    
    private func setFlowLayout(){
        
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
    }

    
    // MARK: - 计算列数,监听屏幕旋转,布局
    private func totalCorBystatusBarOrientation() -> Int{
        
        let drivce = UIDevice.currentDevice()
        
        let model = drivce.model
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        switch orientation {
        case .LandscapeLeft, .LandscapeRight:
            if model == "iPhone Simulator" || model == "iPhone" || model == "iPod touch"{
                return 3
            }else {
                return 4
            }
            
        case .Portrait, .PortraitUpsideDown:
            if model == "iPhone Simulator" || model == "iPhone" || model == "iPod touch"{
                return 2
            }else {
                return 3
            }
        default: return 2
        }
    }
    
    private func layoutCollcetionCell(){
        
        totalLie = totalCorBystatusBarOrientation()
        
        itemWidth = (collectionView!.bounds.width - CGFloat(totalLie + 1) * margin) / CGFloat(totalLie)
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    // MARK: 监听屏幕旋转
    func statusBarOrientationChange(notification: NSNotification) {
        
        layoutCollcetionCell()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layoutCollcetionCell()
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
}
