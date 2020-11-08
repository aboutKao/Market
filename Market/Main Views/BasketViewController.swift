//
//  BasketViewController.swift
//  Market
//
//  Created by Kao on 2020/11/8.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var basketTotalPriceLab: UILabel!
    @IBOutlet weak var totalItemLab: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    var basket: Basket?
    var allItems: [Item] = []
    //購買商品編號
    var purchasedItemIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //判斷使用者是否登入
        loadBasketFromFirestore()
    }

    @IBAction func checkOutBtnPressed(_ sender: Any) {
        
    }
    
    //下載購物車
    private func loadBasketFromFirestore() {
        downloadBasketFromFirestore("1234") { (basket) in
            self.basket = basket
            self.getBasketItem()
        }
    }
    
    private func getBasketItem() {
        
        if basket != nil {
            print("印", basket!.itemIds)
            downloadItems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.tableView.reloadData()
            }
        }
    }

}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        print("印", cell.generateCell(allItems[indexPath.row]))
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
