//
//  ListViewController.swift
//  TE
//
//  Created by 强新宇 on 2018/3/24.
//  Copyright © 2018年 强新宇. All rights reserved.
//

import UIKit
import GPChat

class ListViewController: MessageListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketManager.Default.open()
        
        leftBtn.setImage(nil, for: .normal)
        leftBtn.setTitle("+", for: .normal)

        // Do any additional setup after loading the view.
    }
    override func clickLeftBtn() {
        let alert = UIAlertController.init(title: "", message: "请输入目标ID", preferredStyle: .alert)
        
        let ac = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let ac1 = UIAlertAction.init(title: "确定", style: .default) {[weak self] _ in
            if let idfield = alert.textFields?.first {
                if idfield.text!.utf16.count > 0 {
                    let message = MessageViewController()
                    message.targetID = idfield.text!
                    self?.navigationController?.pushViewController(message, animated: true)
                }
            }
        }
        alert.addAction(ac)
        alert.addAction(ac1)
        
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
