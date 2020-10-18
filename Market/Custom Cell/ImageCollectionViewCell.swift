//
//  ImageCollectionViewCell.swift
//  Market
//
//  Created by Kao on 2020/10/17.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        imageView.image = itemImage
    }
}
