//
//  ListTableViewCell.swift
//  TestStcket
//
//  Created by 强新宇 on 2017/11/7.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

class MessageListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 5
        userImageView.layer.masksToBounds = true
        
        tipView.layer.cornerRadius = tipView.bounds.size.width / 2
        tipView.layer.masksToBounds = true
    }
    
    // MARK: - Handle Data
    var model: ChatListModel? {
        willSet {
            if let m = newValue {
                handleModel(model: m)
            }
        }
    }
    
    func handleModel(model: ChatListModel) {
        print("handleModel",model,model.targetID)
        if let userInfo = DBManager.getUserInfo(targetID: model.targetID) {
            print("userInfo ---- ",userInfo)
            if let url = URL.init(string: userInfo.avatar) {
                print("userInfo ---- url",url)
                userImageView.setImageWith(url, placeholder: nil)
            }
            nameLabel.text = userInfo.name
        }
        
        tipView.isHidden = model.unreadCount == 0
        contentLabel.text = model.lastMessageData
        dateLabel.text = model.lastMessageTimeString
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
