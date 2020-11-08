//
//  ItemTableViewCell.swift
//  Market
//
//  Created by Kao on 2020/9/27.
//  Copyright © 2020 Kao Che. All rights reserved.
//

import UIKit
import SnapKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        self.addSubview(itemImageView)
        itemImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(width * 0.03)
            make.left.equalTo(self.snp.left).offset(width * 0.05)
            make.width.equalTo(width * 0.4)
            make.height.equalTo(width * 0.3)
        }
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(width * 0.04)
            make.left.equalTo(itemImageView.snp.right).offset(width * 0.02)
            make.width.equalTo(width * 0.5)
            make.height.equalTo(width * 0.05)
        }
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(width * 0.01)
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(width * 0.5)
            make.height.equalTo(width * 0.05)
        }
    }

    func generateCell(_ item: Item) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertToCurrency(item.price)
        //自動配置文字寬度
        priceLabel.adjustsFontSizeToFitWidth = true
        //下載圖片
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            downloadImages(imageUrls: [item.imageLinks.first!]) { (images) in
                self.itemImageView.image = images.first as? UIImage
            }
        }
    }
}
