//
//  CategoryCollectionViewController.swift
//  Market
//
//  Created by Kao on 2020/2/7.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit


class CategoryCollectionViewController: UICollectionViewController {

    var categoryArray:[Category] = []
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    private let itemsPerRow:CGFloat = 3.05
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createCategorySet()
        
//        downloadCategoriesFromFirebase { (allCategories) in
//            print("回傳成功")
//        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadCategories()

    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
    
        cell.generateCell(categoryArray[indexPath.row])
    
        return cell
    }
    
    
    // UICollectionVIew Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItemsSeg", sender: categoryArray[indexPath.row])
    }
    
    
    //下載商品類型
    private func loadCategories(){
        downloadCategoriesFromFirebase { (allCategory) in
            print("已獲取",allCategory.count)
            self.categoryArray = allCategory
            self.collectionView.reloadData()
        }
    }
    
    //Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryToItemsSeg"{
            let vc = segue.destination as! ItemsTableViewController
            vc.category = sender as! Category
        }
    }
    
}


extension CategoryCollectionViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: withPerItem, height: withPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
