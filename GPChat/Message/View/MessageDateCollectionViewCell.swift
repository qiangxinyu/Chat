//
//  MessageDateCollectionViewCell.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/17.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

class MessageDateCollectionViewCell: UICollectionViewCell {

    deinit {
        print(self,"deinit")
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLabel.layer.cornerRadius = 5
        dateLabel.layer.masksToBounds = true
    }

}
