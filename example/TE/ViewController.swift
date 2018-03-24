//
//  ViewController.swift
//  TE
//
//  Created by 强新宇 on 2018/3/24.
//  Copyright © 2018年 强新宇. All rights reserved.
//

import UIKit
import GPChat
import TZImagePickerController
class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var avatarBtn: UIButton!
    var key = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        progressView.isHidden = true
        
        if let avatar = UserDefaults.standard.string(forKey: "avatar") {
            avatarBtn.setImageWith(URL.init(with: avatar), for: .normal, placeholder: nil)
            key = avatar
        }

        let name = UserDefaults.standard.string(forKey: "name")
        nameTF.text = name
        let id = UserDefaults.standard.string(forKey: "id")
        idTF.text = id
    }

    @IBAction func clickAvatar(_ sender: Any) {
        if let imagePicker = TZImagePickerController.init(maxImagesCount: 1, delegate: nil) {
            imagePicker.allowPickingVideo = false
            imagePicker.showSelectBtn = true
            imagePicker.allowTakePicture = false
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.didFinishPickingPhotosHandle = {[weak self] photos, assets, isSelectOriginalPhoto in
                if let photo = photos?.first?.imageDataRepresentation() {
                    self?.progressView.isHidden = false
                    self?.progressView.progress = 0

                    let to = UploadTool.uploadImage(data: photo, progress: { (progress) in
                        print("pppp", progress)
                        DispatchQueue.main.async {
                            self?.progressView.progress = progress
                        }
                    }, finish: { (key) in
                        print(key)
                        self?.key = key
                        UserDefaults.standard.setValue(key, forKey: "avatar")
                        self?.progressView.isHidden = true
                        self?.avatarBtn.setImageWith(URL.init(with: key), for: .normal, placeholder: nil)
                    }, fail: {
                        print("error")
                        self?.progressView.isHidden = true

                    })
                    
                    print("to", to)

                }
                
            }
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func click(_ sender: Any) {
        if (idTF.text?.utf16.count == 0) {
            return
        }
        var name = nameTF.text
        if (name?.utf16.count == 0) {
            name = idTF.text
        }
        
        UserDefaults.standard.setValue(key, forKey: "avatar")
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.setValue(idTF.text!, forKey: "id")

        
        SocketManager.setting(id: idTF.text!, name: name!, token: token, avatar: key)

        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

