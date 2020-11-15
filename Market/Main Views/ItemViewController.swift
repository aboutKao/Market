//
//  ItemViewController.swift
//  Market
//
//  Created by Kao on 2020/9/27.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var item: Item!
    var itemImages: [UIImage] = []
    var hud = JGProgressHUD(style: .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let cellHeight: CGFloat = 196.0
    private let itemPerRow: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        downloadPicture()
        
        //左itemBarBtn
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        //右itemBarBtn
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "basket"), style: .plain, target: self, action: #selector(self.addToBasketButtonPressed))]
    }
    
    // 下載圖片
    private func downloadPicture() {
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    

    //建立 UI
    private func setupUI() {
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
        }
    }
   
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func addToBasketButtonPressed() {
        downloadBasketFromFirestore("1234") { (basket) in
            
            //確認用戶是否已登入或顯示登入畫面
            
            if basket == nil {
                self.createNewBasket()
            } else {
                basket!.itemIds.append(self.item.id)
                self.updateBasket(basket: basket!, withValues: [kITEMIDS: basket!.itemIds])
            }
            
            
        }
    }
    
    //新增到購物車
    private func createNewBasket() {
        
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = "1234"
        newBasket.itemIds = [self.item.id]
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "新增到購物車"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateBasket(basket: Basket, withValues: [String: Any]) {
        
        updateBasketInFirestore(basket, withValues: withValues) { (error) in
            
            if error != nil {
                self.hud.textLabel.text = "錯誤：\(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                print("更新購物車失敗", error!.localizedDescription)
            } else {
                self.hud.textLabel.text = "新增到購物車"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
}


extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if itemImages.count == 0 {
            return 0
        } else {
            return itemImages.count
        }
//        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        
        return cell
    }
    
    
}


extension ItemViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionInsets.left
        return CGSize(width: availableWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
