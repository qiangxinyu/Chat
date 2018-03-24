//
//  ListViewController.swift
//  TestStcket
//
//  Created by 强新宇 on 2017/11/7.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

fileprivate let cell_key = "cell_key"

open class MessageListViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Single
    static let Default = MessageListViewController()
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - para

    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    let activityView = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
    
    var chatList = [ChatListModel]()
    
    deinit {
        print("MessageListViewController deinit")
    }
   
    public init() {
        let b1 = Bundle.init(for: RootViewController.self)
        super.init(nibName: "MessageListViewController", bundle: b1)
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatChange), name: chatChangeKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(socketStatusChange(noti:)), name: socketStatusChangeKey, object: nil)

        print("SocketManager.Default.connectCount = 5")
        
        
        chatList = DBManager.Default.chatList
        let b1 = Bundle.init(for: RootViewController.self)

        tableView.register(UINib.init(nibName: "MessageListTableViewCell", bundle: b1), forCellReuseIdentifier: cell_key)
        tableView.tableFooterView = UIView()
        
        self.titleLabel.text = "估品"
        
        
        activityView.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        naviBar.addSubview(activityView)
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    

    // MARK: - Notification
    @objc public func chatChange() {
        chatList = DBManager.Default.chatList
        tableView.reloadData()
    }
    
    @objc public func socketStatusChange(noti: Notification) {
        let center = self.titleLabel.center
        if let status = noti.object as? SocketStaus {
            if status == .Close {
                titleLabel.text = "估品(\(status.rawValue))"
                activityView.stopAnimating()
                activityView.isHidden = true
            } else if status == .Opening {
                titleLabel.text = "估品(\(status.rawValue))"
                activityView.isHidden = false
                activityView.startAnimating()
            } else if status == .Open {
                titleLabel.text = "估品"
                activityView.stopAnimating()
                activityView.isHidden = true
            }
            titleLabel.sizeToFit()
            titleLabel.center = center
            activityView.center = center
            activityView.centerX -= titleLabel.width / 2 + 20
        }
    }
    
    
    // MARK: - TableView Delegate && DataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_key, for: indexPath) as! MessageListTableViewCell
        cell.model = chatList[indexPath.row]
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chat = chatList[indexPath.row]
        chat.unreadCount = 0
        chat.update()
        tableView.reloadRow(at: indexPath, with: .none)
        
        DBManager.Default.currentChat = chat
        
        let message = MessageViewController()
        message.title = DBManager.getUserInfo(targetID: chat.targetID)?.name
        message.targetID = chat.targetID
        message.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(message, animated: true)
        
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        chatList.remove(at: indexPath.row)
        tableView.deleteRow(at: indexPath, with: .automatic)
        tableView.endUpdates()
        
        DBManager.removeChat(index: indexPath.row)
    }


    override open func didReceiveMemoryWarning() {
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
