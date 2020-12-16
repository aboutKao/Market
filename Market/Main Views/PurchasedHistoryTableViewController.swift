//
//  PurchasedHistoryTableViewController.swift
//  Market
//
//  Created by KaoChe on 2020/11/28.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class PurchasedHistoryTableViewController: UITableViewController {
    
    var itemArray: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }
    

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }
    
    private func loadItems() {
        downloadItems(MUser.currentUser()!.purchasedItemIds) { (allItems) in
            self.itemArray = allItems
            print("獲得\(allItems.count)個已購買項目")
            self.tableView.reloadData()
        }
    }
}

extension PurchasedHistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "沒有購買紀錄")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptydata")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "找不到您購買的紀錄")
    }
}
