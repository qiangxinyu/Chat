//
//  MessageViewController.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/11/16.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import TZImagePickerController
import MJRefresh
import YYKit


open class MessageViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var targetID = ""
    var startID = 0
    var hasMoreData = true
    
    var listArray = [MessageModel]()
    var imagesList = [MessageModel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageInputView: MessageInputView!
    @IBOutlet weak var messageInputViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var messageViewTop: NSLayoutConstraint!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewBottom: NSLayoutConstraint!
    var messageViewBottomDefualt: CGFloat = -65
    
    // MARK: - VC Method
    override open var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    public init() {
        super.init(nibName: "MessageViewController", bundle: Bundle.Default())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        kNotificationCenter.removeObserver(self)
        print(self,"deinit",listArray.count)
        
        for m in listArray {
            print(m)
            m.clearSelf()
        }
        MessageAlbumView.clear()

        listArray.removeAll()
        imagesList.removeAll()
    }
    
   
    override open func viewDidLoad() {
        super.viewDidLoad()
       
        if !IS_iOS11 {
            messageViewTop.constant = naviBarHeight
        }
       
        navigationController?.interactivePopGestureRecognizer?.delaysTouchesBegan = false 
        
        collectionView.delaysContentTouches = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChange(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessage(noti:)), name: receiveMessageKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(socketStatusChange(noti:)), name: socketStatusChangeKey, object: nil)

        navigationController?.interactivePopGestureRecognizer?.delaysTouchesBegan = false
        
        collectionView.register(UINib.init(nibName: "MessageDateCollectionViewCell", bundle: Bundle.Default()), forCellWithReuseIdentifier: MessageCellType.Date.rawValue)
        collectionView.register(MessageSenderCollectionViewCell.self, forCellWithReuseIdentifier: MessageCellType.Sender.rawValue)
        collectionView.register(MessageReceiveCollectionViewCell.self, forCellWithReuseIdentifier: MessageCellType.Receive.rawValue)
        
        let tap = UITapGestureRecognizer.init { [weak self] _ in
            self?.endInput()
        }
        collectionView.addGestureRecognizer(tap)
        
        startID = DBManager.getCount(targetID: targetID) - message_limit
        
        if let list:[MessageBaseModel] = DBManager.getObjects(targetID: targetID, startID: startID) {
            
            DispatchQueue.main.async {[weak self] in
                for m in list {
                    let model = MessageModel.init(messageBaseModel: m, targetID: self!.targetID, isDB: true)
                    self!.listArrayAppend(inserModel: model, isInit: true)
                    self!.reloadDataDownload(model: model)
                    
                    if model.type == .image {
                        self!.imagesList.append(model)
                    }
                }
                
                self!.startID -= list.count
                if self!.startID <= 0 {
                    self!.hasMoreData = false
                } else {
                    self!.addHeader()
                }
                self?.collectionView.reloadData()
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
            self!.collectionView.scrollToBottom()
        })
        
        let flow =  UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flow
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        
        // MARK: - InputView Handle
        messageInputView.heightHandle = { [weak self] height in
            self?.messageInputViewHeight.constant = height + 115
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self?.collectionView.scrollToBottom()
            })
            
            if height == 0 && self!.messageViewBottom.constant == 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    self?.messageViewBottom.constant = self!.messageViewBottomDefualt
                    self?.view.layoutIfNeeded()
                })
            }
        }
        
        messageInputView.audioHandle = {[weak self] url in
            self?.sentAudio(url: url)
        }
        messageInputView.textHandle = { [weak self] text in
            self?.sentText(text: text)
        }
        
        messageInputView.clickFunctionBtnHandle = { [weak self] in
            self?.isHandleFunction = true
            self?.view.endEditing(true)
            UIView.animate(withDuration: 0.25, animations: {
                self?.messageViewBottom.constant = self!.messageViewBottom.constant == 0 ? self!.messageViewBottomDefualt : 0
                self?.collectionView.mj_offsetY += self!.messageViewBottom.constant == 0 ? -self!.messageViewBottomDefualt : self!.messageViewBottomDefualt
                self?.view.layoutIfNeeded()
            }, completion: { _ in
                self?.isHandleFunction = false
                self?.collectionView.scrollToBottom()
            })
        }
        
        messageInputView.mediaHandle = {[weak self] isPhoto in
            if isPhoto {
                if let imagePicker = TZImagePickerController.init(maxImagesCount: 9, delegate: nil) {
                    imagePicker.allowPickingVideo = false
                    imagePicker.showSelectBtn = true
                    imagePicker.allowTakePicture = false
                    imagePicker.modalPresentationStyle = .overCurrentContext
                    imagePicker.didFinishPickingPhotosHandle = { photos, assets, isSelectOriginalPhoto in
                        self?.sentPhoto(photos: photos)
                    }
                    self?.present(imagePicker, animated: true, completion: nil)
                }
            } else {
                let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch authStatus {
                case .restricted, .denied:
                    alert(message: "无相机使用权限", sureText: "设置", sureBlock: { _ in
                        UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
                    }, cancleText: "取消", cancleBlock: nil, viewController: self)
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                        
                    })
                default: self?.pushImagePickerController()
                }
            }
        }
    }
    
    // MARK: - Notification
    var isHandleFunction = false
    @objc func keyBoardChange(noti: Notification) {
        if isHandleFunction {return}
        if let userInfo = noti.userInfo {
            if let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    let height = frame.origin.y == kScreenHeight ? 0 : frame.size.height
                    self?.messageViewBottom.constant = height + self!.messageViewBottomDefualt
                    self?.collectionView.mj_offsetY += height
                    self?.view.layoutIfNeeded()
                    }, completion: {[weak self] _ in
                        self?.collectionView.scrollToBottom()
                })
            }
        }
    }
    
    @objc func receiveMessage(noti: Notification) {
        if let msg = noti.object as? Message {
            if msg.type == .message {
                if msg.messageData.userInfo.id != targetID {
                    return
                }
                let model = MessageModel.init(message: msg, targetID: targetID)
                addModel(model: model)
                
            } else if msg.type == .receive {
                let reveice = msg.receiveData
                
                for model in listArray.reversed() {
                    if model.messageBaseModel.time == reveice.sendTime {
                        model.status = MessageStatus.Normal
                        model.messageBaseModel.status = model.status!.rawValue
                        model.messageBaseModel.MsgID = reveice.messageID
                        
                        DispatchQueue.main.async {[weak self] in
                            if let cell = self!.collectionView.cellForItem(at: model.indexPath) as? MessageRootCollectionViewCell {
                                cell.handleStatus(model: model)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func socketStatusChange(noti: Notification) {
        if let status = noti.object as? SocketStaus, status == .Close {
            for model in listArray {
                if model.status == .Sending {
                    if let cell = collectionView.cellForItem(at: model.indexPath) as? MessageRootCollectionViewCell {
                        model.status = .SendFailed
                        cell.handleStatus(model: model)
                    }
                }
            }
        }
    }
    
    // MARK: - Method
    func addHeader() {
        collectionView.mj_header = MJRefreshHeader.init(refreshingBlock: {[weak self] in
            if let weakSelf = self {
                DispatchQueue.main.async {
                    if let list:[MessageBaseModel] = DBManager.getObjects(targetID: weakSelf.targetID, startID: weakSelf.startID) {
                        var items = [IndexPath]()
                        var height: CGFloat = 0
                        for index in (0..<list.count).reversed() {
                            let model = MessageModel.init(messageBaseModel: list[index], targetID: weakSelf.targetID, isDB: true)
                            weakSelf.listArray.insert(model, at: 0)
                            if model.type == .image {
                                weakSelf.imagesList.append(model)
                            }
                            items.append(IndexPath.init(row: index, section: 0))
                            height += model.height + cellAddHeight
                        }
                        
                        UIView.animate(withDuration: 0, animations: {
                            weakSelf.collectionView.performBatchUpdates({
                                weakSelf.collectionView.insertItems(at: items)
                            }, completion: { _ in
                                weakSelf.collectionView.setContentOffset(CGPoint.init(x: 0, y: height - 50), animated: false)
                            })
                        })
                        
                        if weakSelf.startID == 0 {
                            message_limit = 20
                            weakSelf.hasMoreData = false
                            weakSelf.collectionView.mj_header.removeFromSuperview()
                        } else {
                            if weakSelf.startID > message_limit {
                                weakSelf.startID -= list.count
                            } else {
                                message_limit = weakSelf.startID
                                weakSelf.startID = 0
                            }
                        }
                        
                        if weakSelf.collectionView.mj_header != nil {
                            weakSelf.collectionView.mj_header.endRefreshing()
                        }
                    }
                }
                
            }
        })
        
        let activView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activView.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        activView.center = CGPoint.init(x: collectionView.mj_header.width / 2, y: collectionView.mj_header.height / 2)
        activView.startAnimating()
        collectionView.mj_header.addSubview(activView)
    }
    
    func endInput() {
        if messageViewBottom.constant != messageViewBottomDefualt {
            if messageViewBottom.constant == 0 {
                UIView.animate(withDuration: 0.4) { [weak self] in
                    self?.messageViewBottom.constant = self!.messageViewBottomDefualt
                    self?.collectionView.mj_offsetY += self!.messageViewBottomDefualt
                    self?.view.layoutIfNeeded()
                }
            } else {
                view.endEditing(true)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: textview_clear_select_range_key), object: nil)
    }
    
    
    func listArrayAppend(inserModel: MessageModel, isInit: Bool) {
        var dateIndex: IndexPath?
        if let model = listArray.last {
            if inserModel.messageBaseModel.time > model.messageBaseModel.time,
                inserModel.messageBaseModel.time - model.messageBaseModel.time > 180000
            {
                listArray.append(MessageModel.init(model: inserModel))
                dateIndex = IndexPath.init(row: listArray.count - 1, section: 0)
            }
        }
        
        if listArray.count == 0 {
            listArray.append(MessageModel.init(model: inserModel))
            dateIndex = IndexPath.init(row: listArray.count - 1, section: 0)
        }
        
        listArray.append(inserModel)
        
        if !isInit {
            if listArray.last?.type == .image {
                imagesList.append(listArray.last!)
            }
            collectionView.performBatchUpdates({[weak self] in
                let index = IndexPath.init(row: listArray.count - 1, section: 0)
                if dateIndex != nil {
                    self?.collectionView.insertItems(at: [dateIndex!,index])
                } else {
                    self?.collectionView.insertItems(at: [index])
                }
                }, completion: {[weak self] _ in
                    self?.collectionView.scrollToBottom()
            })
        }
    }
    
    func reloadCollectionView() {
        if listArray.last?.type == .image {
            imagesList.append(listArray.last!)
        }
        collectionView.performBatchUpdates({[weak self] in
            self?.collectionView.insertItems(at: [IndexPath.init(row: listArray.count - 1, section: 0)])
            }, completion: {[weak self] _ in
                self?.collectionView.scrollToBottom()
        })
    }
    
    func addModel(model: MessageModel)  {
        listArrayAppend(inserModel: model, isInit: false)
        reloadDataDownload(model: model)
    }
    
    func reloadDataDownload(model: MessageModel) {
        model.reloadDataHandle = {[weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadItems(at: [model.indexPath])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self?.collectionView.scrollToBottom()
            })
        }
    }
    
    // MARK: - Click Method
    @IBAction func clickBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - CollectionView Delegate && DataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listArray.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = listArray[indexPath.row]
        model.indexPath = indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.cellType!.rawValue, for: indexPath)
        if model.cellType == .Date {
            let cell = cell as! MessageDateCollectionViewCell
            cell.dateLabel.text = " \(model.timeString) "
        } else {
            let cell = cell as! MessageRootCollectionViewCell
            cell.model = model
            
            cell.clickImageHandle = {[weak self] m, rect in
                if let index = self?.imagesList.index(of: m) {
                    MessageAlbumView.show(imagesList: (self?.imagesList)!, rect: rect!, index: index)
                }
            }
            cell.tapHandle = {[weak self] in
                 self?.endInput()
            }
            
            cell.errorHandle = { [weak self] model in
                alert(message: "确定要重发此消息吗", sureText: "确定", sureBlock: { (_) in
                    var indexs = [IndexPath]()
                    if let index = self!.listArray.index(of: model) {
                        self?.listArray.remove(at: index)
                        model.status = MessageStatus.Sending
                        model.messageBaseModel.time = UInt64(Date().timeIntervalSince1970 * 1000)
                        model.reloadDB()

                        if index > 0, self!.listArray[index - 1].cellType == .Date {
                            if (index + 1 < self!.listArray.count && self!.listArray[index - 1].cellType != .Date) ||
                                index + 1 >= self!.listArray.count
                            {
                                self?.listArray.remove(at: index - 1)
                                indexs.append(IndexPath.init(row: index - 1, section: 0))
                            }
                        }
                    }
                    indexs.append(model.indexPath)
                    
                    self?.collectionView.performBatchUpdates({
                        self?.collectionView.deleteItems(at: indexs)
                    }, completion: { (_) in
                        self?.addModel(model: model)
                        
                        if model.type == .voice {
                            self?.uploadVoice(model: model)
                        } else if model.type == .text {
                            self?.sendData(model: model)
                        } else if model.type == .image {
                            if let index = self!.imagesList.index(of: model) {
                                self?.imagesList.remove(at: index)
                            }
                            self?.uploadImage(model: model)
                        }
                    })
                }, cancleText: "取消", cancleBlock: nil, viewController: self)
            }
            
            cell.clickURLHanlde = {[weak self] url in
                let wvc = WebViewController()
                wvc.url = url
                self?.navigationController?.pushViewController(wvc, animated: true)
            }
        }
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kScreenWidth, height: listArray[indexPath.row].height + cellAddHeight)
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreenWidth, height: 10)
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreenWidth, height: 10)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        endInput()
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endInput()
    }
    
    // MARK: - ImagePicker && Delegate
    func pushImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.navigationBar.barTintColor = naviBar.backgroundColor
        imagePicker.navigationBar.tintColor = naviBar.backgroundColor
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let i = image.normalizedImage() {
                sentPhoto(photos: [i])
            }
        }
    }
    
    
    // MARK: - Sent Message
    func sentPhoto(photos: [UIImage]?) {
        endInput()
        if let photos = photos {
            for image in photos {
                let model = MessageModel.init(imageStr: "", image: image, targetID: targetID)
                addModel(model: model)
                uploadImage(model: model)
                updateChat(model: model)
            }
        }
    }
    
    func uploadImage(model: MessageModel)  {
        if SocketManager.Default.status != .Open {
            sendFail(model: model)
            return
        }
        if model.image != nil, let data = UIImageJPEGRepresentation(model.image!, 1) {
            let key = UploadTool.uploadImage(data: data, progress:nil, finish: {[weak self] _ in
                self?.sendData(model: model)
            }, fail: {[weak self] in
                self?.sendFail(model: model)
            })
            let ic = YYImageCache.shared()
            ic.setImage(model.image!, imageData: nil, forKey: key, with: YYImageCacheType.disk)
            model.messageBaseModel.data = key
            model.updateDB()
        }
    }
    
    func sentAudio(url: URL) {
        let model = MessageModel.init(voiceURL: url, targetID: targetID)
        addModel(model: model)
        uploadVoice(model: model)
        updateChat(model: model)
    }
    
    func uploadVoice(model: MessageModel) {
        if SocketManager.Default.status != .Open {
            sendFail(model: model)
            return
        }
        if let url = URL.init(string: model.messageBaseModel.data) {
            do {
                let data = try Data.init(contentsOf: url)
                UploadTool.uploadVoice(data: data, progress:nil, finish: {[weak self] key in
                    model.messageBaseModel.data = key
                    AudioManager.setAudioURL(url: key, audioURL: url.absoluteString)
                    model.updateDB()
                    self?.sendData(model: model)
                }, fail: {[weak self] in
                    self?.sendFail(model: model)
                })
            } catch {
                print("sentAudio error \(error)")
            }
        }
    }
    
    func sentText(text: String) {
        let model = MessageModel.init(text: text, targetID: targetID)
        addModel(model: model)
        sendData(model: model)
        updateChat(model: model)
    }
    
    func sendData(model: MessageModel) {
        if SocketManager.Default.status == .Open {
            SocketManager.send(data: model.modelToData())
        } else {
            sendFail(model: model)
        }
    }
    
    func updateChat(model: MessageModel) {
        // 发送的最后一条数据计入聊天列表
        var msg = Message()
        msg.type = .message
        
        var messageData = MessageData.init(model: model.messageBaseModel)
        messageData.userInfo = model.userInfo
        
        msg.messageData = messageData
        
        DBManager.updateChat(data: messageData, targetID: targetID)
        NotificationCenter.default.post(name: chatChangeKey , object: msg)
    }
    
    func sendFail(model: MessageModel) {
        model.status = .SendFailed
        collectionView.performBatchUpdates({[weak self] in
            self?.collectionView.reloadItems(at: [model.indexPath])
        }, completion: nil)
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
