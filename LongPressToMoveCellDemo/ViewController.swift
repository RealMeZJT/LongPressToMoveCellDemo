//
//  ViewController.swift
//  LongPressToMoveCellDemo
//
//  Created by ZhouJiatao on 2018.01.26.
//  Copyright © 2018 ZJT. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var objs = ["hello", "world","!!!!","Xcode","iOS","code"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "StandardCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = objs[indexPath.row]
        
        return cell
    }
    
    //MARK: - 以下是本demo的关键代码
    @objc func longPressGestureRecognized(_ gesture: UILongPressGestureRecognizer) {
        struct Keep {
            static var snapshot: UIView?    //用户要移动的cell的快照
            static var sourceIndexPath: IndexPath?  //cell的原位置
        }
        
        switch gesture.state {
        case .began:
            
            guard let sourceIndexPath = tableView.indexPathForRow(at: gesture.location(in: tableView)) else {
                break
            }
            
            Keep.sourceIndexPath = sourceIndexPath
            
            guard let cell = tableView.cellForRow(at: sourceIndexPath) else {
                break
            }
            
            Keep.snapshot = customSnapshotFromView(cell)
            var center = cell.center
            Keep.snapshot?.center = center
            Keep.snapshot?.alpha = 0.0
            tableView.addSubview(Keep.snapshot!)
            UIView.animate(withDuration: 0.25, animations: {
                center.y = gesture.location(in: self.tableView).y
                Keep.snapshot?.center = center
                Keep.snapshot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                Keep.snapshot?.alpha = 0.98
                
                cell.alpha = 0.0
                
            }, completion: { (finished) in
                cell.isHidden = true
            })
            
        case .changed:
            guard let snapshot = Keep.snapshot else {
                break
            }
            snapshot.center = CGPoint(x: snapshot.center.x, y: gesture.location(in: tableView).y)
            
            guard let indexPath = tableView.indexPathForRow(at: gesture.location(in: tableView)) else {
                break
            }
            
            if indexPath != Keep.sourceIndexPath! {
                objs.swapAt(indexPath.row, Keep.sourceIndexPath!.row)
                tableView.moveRow(at: Keep.sourceIndexPath!, to: indexPath)
                Keep.sourceIndexPath = indexPath
            }
            
        default:
            guard let sourceIndexPath = Keep.sourceIndexPath else {
                break
            }
            guard let cell = tableView.cellForRow(at: sourceIndexPath) else {
                break
            }
            cell.isHidden = false
            cell.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
                Keep.snapshot?.center = cell.center
                Keep.snapshot?.transform = CGAffineTransform.identity
                Keep.snapshot?.alpha = 0.0
                
                cell.alpha = 1.0
            }, completion: { (finished) in
                Keep.sourceIndexPath = nil
                Keep.snapshot?.removeFromSuperview()
                Keep.snapshot = nil
            })
            
        }
        
    }
    
    func customSnapshotFromView(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
    
    
}

