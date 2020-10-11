//
//  CategoryCollectionViewCell.swift
//  Market
//
//  Created by Kao on 2020/2/7.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    
    func generateCell (_ category:Category){
        
        nameLabel.text = category.name
        imageView.image = category.image
    }
    
}
