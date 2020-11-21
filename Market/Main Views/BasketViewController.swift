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
    let width = UIScreen.main.bounds.width
    
    
    @IBOutlet weak var deleteAll: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView
        setupCheckBtn()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //判斷使用者是否登入
        loadBasketFromFirestore()
        
        if basket?.itemIds != nil {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }

    @IBAction func deletaAllAction(_ sender: Any) {
        
        for i in 0...(basket?.itemIds.count)! {
            if i != 0 {
                removeFromBasket(itemId: allItems[i - 1].id)
                
                updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket!.itemIds]) { (error) in
                    if error != nil {
                        print("刪除商品時購物車更新失敗", error?.localizedDescription)
                    }
                    self.getBasketItem()
                }
            }

                tableView.isHidden = true
            
        }
        
        
        
        
        
        
    }
    
    @IBAction func checkOutBtnPressed(_ sender: Any) {
        
    }
    
    
    private func setupCheckBtn() {
        self.view.addSubview(checkOutBtn)
        checkOutBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).inset(width * 0.25)
            make.left.right.equalTo(0)
            make.height.equalTo(width * 0.1)
            make.width.equalTo(width)
        }
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
            downloadItems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                //購物車有商品時計算總額
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        } else {
            self.updateTotalLabels(true)
        }
    }
    
    private func updateTotalLabels(_ isEmptys: Bool) {
        if isEmptys {
            totalItemLab.text = "0"
            basketTotalPriceLab.text = returnBasketTotalPrice()
            checkOutBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        } else {
            //購物車有商品時顯示有幾個商品及價格總額
            totalItemLab.text = "\(allItems.count)"
            basketTotalPriceLab.text = returnBasketTotalPrice()
        }
    }

    //更新按鈕狀態
    
    private func returnBasketTotalPrice() -> String {
        var totalPrice = 0.0
        
        for item in allItems {
            totalPrice += item.price
        }
        //轉換貨幣
        return "總計：" + convertToCurrency(totalPrice)
    }
    
    //Navigation
    private func showItemView(withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
            self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    
    //確認Btn控制
    private func checkoutButtonStatusUpdate() {
        //allItem數量>0才能點選checkoutBtn
        checkOutBtn.isEnabled = allItems.count > 0
        
        if checkOutBtn.isEnabled {
            checkOutBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            disableCheckoutButton()
        }
    }
    
    private func disableCheckoutButton() {
        checkOutBtn.isEnabled = false
        checkOutBtn.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    private func removeFromBasket(itemId: String) {
        for i in 0..<basket!.itemIds.count {
            if itemId == basket!.itemIds[i] {
                basket!.itemIds.remove(at: i)
                return
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
        print("印數量", indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.3
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //向左滑動
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            removeFromBasket(itemId: itemToDelete.id)
            updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket!.itemIds]) { (error) in
                if error != nil {
                    print("刪除商品時購物車更新失敗", error?.localizedDescription)
                }
                self.getBasketItem()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
        
    }
}
