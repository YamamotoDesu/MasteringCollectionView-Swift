//
//  ViewController.swift
//  MasteringCollectionView
//
//  Created by 山本響 on 2021/06/19.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomNav: UINavigationBar!
    
    var data = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🐔", "🐧", "🐦", "🐤",  "🐥","🦆","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝","🐛","🦋","🐌","🐞","🐜","🦟","🦗","🕷","🦂","🐢","🐍","🦎","🦖","🦕","🐙","🦑","🦐","🦞","🦀","🐡","🐠","🐟","🐬","🐳"]
    
    let refreshControll = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let numOfColumn = 3
        let width = (self.view.frame.size.width - CGFloat(numOfColumn - 1) * 10) / CGFloat(numOfColumn)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        refreshControll.addTarget(self, action: #selector(appendNewItem), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControll
        
        navigationItem.leftBarButtonItem = editButtonItem
        addLongPressToCollectionView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        addBarButton.isEnabled = !isEditing
        bottomNav.isHidden = !isEditing
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        })
        collectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = collectionView.cellForItem(at: indexPath) as! CustomCell
            cell.isEditing = editing
        }
        
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let selectedItem = sender as? String else {
//            return
//        }
        
        guard let index = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let selectedItem = data[index.item]
        
        if segue.identifier == "detail" {
            guard let destinationVC = segue.destination as? DetailViewController else {
                return
            }
            
            destinationVC.selectedData = selectedItem
        }
    }
    
    @IBAction func insertNewItem() {
        insertMutileItems()
    }
    
    func insertOneItem(_ test: String = "🍓") {
        data.append(test)
        let indexPath = IndexPath(row: data.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    func insertMutileItems() {
        collectionView.performBatchUpdates({
            for _ in 0..<5 {
                insertOneItem("🥦")
            }
        }, completion: nil)
    }
    
    //refresh control selector
    @objc func appendNewItem() {
        let test = "⭐️"
        data.insert(test, at: 0)
        //collectionView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
        collectionView.refreshControl?.endRefreshing()
    }
    
    @IBAction func deleteSelectedItems(_ sender: UIBarButtonItem) {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            let items = selectedItems.map{$0.item}.sorted().reversed()
            for item in items {
                data.remove(at: item)
            }
            collectionView.deleteItems(at: selectedItems)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
//        if let label = cell.viewWithTag(100) as? UILabel {
//            label.text = data[indexPath.row]
//        }
        cell.itemLabel.text = data[indexPath.item]
        cell.isEditing = isEditing
        return cell
    }
    
    // cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            let selectedData = data[indexPath.item]
            self.performSegue(withIdentifier: "detail", sender: selectedData)
        }
    }
    
    //cell  move
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = data.remove(at: sourceIndexPath.item)
        data.insert(item, at: destinationIndexPath.item)
    }
    
    func addLongPressToCollectionView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        self.collectionView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}
