//
//  MemoListViewController.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit
import CoreData

let reuseIdentifier = "Cell"

let backColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)

class MemoListViewController: MemoCollectionViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    private lazy var searchBar = UISearchBar()
    let context = CoreDataStack.shardedCoredataStack.managedObjectContext!

    var fetchedResultsController: NSFetchedResultsController?
    
    private lazy var searchView = UIView()
    
    var isSearching: Bool = false
    
    var searchResults: [Memo] = []
    
    var didSelectedSearchResultIndexPath: NSIndexPath? // 被选中的搜索结果的索引
    
    private lazy var addItem: UIBarButtonItem = {
        
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addMemo")
        
        return item
    }()
    
    private lazy var settingItem: UIBarButtonItem = {
       
        let item = UIBarButtonItem(image: UIImage(named: "EverNoteIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "setting")
        
        return item
    }()
    
    private lazy var searchItem: UIBarButtonItem = {
       
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "search")
        
        return item
    }()
    
    /// 加载fetchedResultsController
    private func loadFetchedResultsController() -> NSFetchedResultsController {
        
        let request = NSFetchRequest(entityName: "Memo")
        
        let sortDescriptor = NSSortDescriptor(key: "changeDate", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        let controller  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = backColor
        
        setNavigationBar()
        
        fetchedResultsController = loadFetchedResultsController()
        fetchedResultsController!.performFetch(nil)
        
        // Register cell classes
        self.collectionView!.registerClass(MemoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        sharedDataToWatch()
      
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if isSearching {
            
            searchBar.becomeFirstResponder()
            
        }
        
        if ENSession.sharedSession().isAuthenticated {
            uploadMemoToEvernote()
        }
        
        sharedDataToWatch()
        
    }
    

    
    private lazy var titleLabel: UILabel = {
       
        let label = UILabel()
        
        label.text = "便签"
        label.font = UIFont.systemFontOfSize(18)
        label.sizeToFit()
        
        return label
        
    }()
    
    private func setNavigationBar(){
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItems = [addItem]
        
        settingItem.tintColor = ENSession.sharedSession().isAuthenticated ? UIColor(red: 23/255.0, green: 127/255.0, blue: 251/255.0, alpha: 1) : UIColor.grayColor()
        
        navigationItem.leftBarButtonItems = [settingItem, searchItem]
    }
    
    func setting(){
        
        if ENSession.sharedSession().isAuthenticated {
            
            let alert = UIAlertController(title: "退出印象笔记?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "退出", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                
                ENSession.sharedSession().unauthenticate()

                self.settingItem.tintColor = UIColor.grayColor()
                
            }))
            
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            ENSession.sharedSession().authenticateWithViewController(self, preferRegistration: false, completion: { (error: NSError?) -> Void in
                
                if error == nil {
                    
                    self.settingItem.tintColor = UIColor(red: 23/255.0, green: 127/255.0, blue: 251/255.0, alpha: 1)

                }
                
            })
        }
    
    }
    
    /// 搜索
    func search(){
        
        navigationItem.rightBarButtonItems?.removeAll(keepCapacity: true)
        navigationItem.leftBarButtonItems?.removeAll(keepCapacity: true)
        
        
        searchBar.searchBarStyle = .Minimal
        searchBar.setShowsCancelButton(true, animated: true)
        
        
        searchBar.delegate = self
        
        searchBar.backgroundColor = backColor
        
        // 如果将searchView直接添加到navigationBar上, 但push到下一个界面时, searchView还在navigationBar上
//        navigationController?.navigationBar.addSubview(searchView)
        navigationItem.titleView = searchView
        
        searchView.frame = navigationController!.navigationBar.bounds
        
        searchView.addSubview(searchBar)
        
        var margin: CGFloat!
        if deviceModel == "iPad" || deviceModel == "iPad Simulator" {
            margin = 30
        }else {
            margin = 10
        }
        
        searchBar.frame = CGRect(x: 0, y: 0, width: searchView.bounds.width - margin, height: searchView.bounds.height)
        
        searchBar.becomeFirstResponder()
        
        isSearching = true
        
        if !searchBar.text.isEmpty {
            
            fetchSearchResults(searchBar.text)
        }
        
        collectionView?.reloadData()

        
    }
    
    private func fetchSearchResults(searchText: String){
        
        let request = NSFetchRequest(entityName: "Memo")
        request.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchText)
        
        let sortDescriptor = NSSortDescriptor(key: "changeDate", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        var error: NSError?
        let results = CoreDataStack.shardedCoredataStack.managedObjectContext?.executeFetchRequest(request, error: &error)
        if let resultmemos = results as? [Memo] {
            
            searchResults = resultmemos
            
        }
        
    }
    
    // MARK: searchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        fetchSearchResults(searchText)
        
        collectionView?.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchView.removeFromSuperview()
        
        setNavigationBar()
        
        isSearching = false
        
        searchResults.removeAll(keepCapacity: false)
        
        collectionView?.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()

    }
    
    override func statusBarOrientationChange(notification: NSNotification) {
        super.statusBarOrientationChange(notification)
        
        searchBarCancelButtonClicked(searchBar)
                
    }
    
    func addMemo(){
        
        let memoVC =  MemoViewController()
        
        navigationController?.pushViewController(memoVC, animated: true)
//        presentViewController(memoVC, animated: true, completion: nil)
        
    }
    
    
        // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return  (isSearching ? searchResults.count : fetchedResultsController!.fetchedObjects!.count)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemoCell
    
        var memo: Memo!
        if isSearching {
            
            memo = searchResults[indexPath.row]
            
        }else{
            memo = fetchedResultsController!.objectAtIndexPath(indexPath) as! Memo
            
            // 删除笔记的闭包
            cell.deleteMemo = {(memo: Memo) -> () in
                
                let alert = UIAlertController(title: "删除便签", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
                
                // .Destructive 需要谨慎操作的工作,文字会自动设为红色
                alert.addAction(UIAlertAction(title: "删除", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                    
                    memo.deleteFromEvernote()
                    
                    CoreDataStack.shardedCoredataStack.managedObjectContext?.deleteObject(memo)
                    
                    CoreDataStack.shardedCoredataStack.saveContext()
                    
                    self.sharedDataToWatch()
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }

        }
        cell.memo = memo
        
        
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        searchBar.resignFirstResponder()
        
        var memo: Memo!
        if isSearching{
            
            memo = searchResults[indexPath.row]
            
            didSelectedSearchResultIndexPath = indexPath
            
        }else{
            memo = fetchedResultsController?.objectAtIndexPath(indexPath) as! Memo
        }
        let MemoView = MemoViewController()
        
        MemoView.memo = memo
        
        navigationController?.pushViewController(MemoView, animated: true)
        
    }

    // MARK: - NSFetchedResultsControllerDelegate
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        
        // 如果处于搜索状态, 内容更新了,就重新搜索,重新加载数据
        if isSearching {
            
            fetchSearchResults(searchBar.text)
            
            collectionView?.reloadData()
            
            return
        }
        
        switch(type){
            
        case .Insert:
            
            collectionView!.insertItemsAtIndexPaths([newIndexPath!])
            
        case .Update:
            
            collectionView?.reloadItemsAtIndexPaths([indexPath!])
            
        case .Delete:
            
            collectionView?.deleteItemsAtIndexPaths([indexPath!])
            
        case .Move:
            
            collectionView?.moveItemAtIndexPath(indexPath!, toIndexPath:newIndexPath!)
            collectionView?.reloadItemsAtIndexPaths([newIndexPath!])
            
        }
    }
    
    // MARK: - 上传便签到印象笔记
    private func uploadMemoToEvernote(){
        
        // 取出所有没有上传的memo
        
        let predicate = NSPredicate(format: "isUpload == %@", false)
        
        let request = NSFetchRequest(entityName: "Memo")
        
        request.predicate = predicate
        
        var error: NSError?
        
        let results = CoreDataStack.shardedCoredataStack.managedObjectContext?.executeFetchRequest(request, error: &error)
        if let unUploadMemos = results as? [Memo] {
            
            for unUploadMemo in unUploadMemos {
                
                let memo = unUploadMemo as Memo
                
                // 上传便签到印象笔记
                memo.uploadToEvernote()
                
            }
        }
    }
    
    // MARK: - 分享数据给Apple Watch
    /// 分享数据给apple Watch
    private func sharedDataToWatch(){
        
        let sharedDefaults = NSUserDefaults(suiteName: "group.likumb.com.Memo")
        
        var results = [[String: AnyObject]]()
        
        if fetchedResultsController?.fetchedObjects == nil {
            return
        }
        
        let count = fetchedResultsController!.fetchedObjects!.count > 10 ? 10 : fetchedResultsController!.fetchedObjects!.count
        
        for index in 0..<count {
            
            let memo = fetchedResultsController!.fetchedObjects![index] as! Memo
            var watchMemo = [String: AnyObject]()
            watchMemo["text"] = memo.text
            watchMemo["changeDate"] = memo.changeDate
            
            results.append(watchMemo)
            
        }
    
        sharedDefaults?.setObject(results, forKey: "WatchMemo")

        sharedDefaults!.synchronize()
        
        
    }
    
}
