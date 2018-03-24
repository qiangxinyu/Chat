//
//  XYRootViewController.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/10/25.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

open class RootViewController: UIViewController {

    // MARK: - Base
    deinit {
        kNotificationCenter.removeObserver(self)
    }

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        
        initNaviBar()
        titleLabel.text = title
    }
    
    
    // MARK: - Screen Turn
    override open var shouldAutomaticallyForwardAppearanceMethods: Bool {return false}
    override open var shouldAutorotate: Bool {return false}

    
    // MARK: - NaviBar
    public var naviBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: naviBarHeight))
    public var titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth - 100, height: 20))
    public var leftBtn = UIButton.init(type: .custom)
    public var rightBtn = UIButton.init(type: .custom)
    
    func initNaviBar() {
        naviBar.backgroundColor = UIColor.init(hexString: "34333A")
        view.addSubview(naviBar)
        
        titleLabel.center = CGPoint.init(x: kScreenWidth / 2, y: 42 + naviBarTop)
        titleLabel.font = UIFont.firstTitleTextFont()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = naviBar.backgroundColor
        naviBar.addSubview(titleLabel)
        
        rightBtn.backgroundColor = naviBar.backgroundColor
        rightBtn.titleLabel?.font = UIFont.secondTitleTextFont()
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 42)
        rightBtn.center = CGPoint.init(x: kScreenWidth - 45 / 2 - 15, y: 42 + naviBarTop)
        rightBtn.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
        
        
        leftBtn.backgroundColor = naviBar.backgroundColor
        leftBtn.titleLabel?.font = UIFont.secondTitleTextFont()
        leftBtn.setTitleColor(UIColor.white, for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 42)
        leftBtn.center = CGPoint.init(x: 15, y: 42 + naviBarTop)
        leftBtn.addTarget(self, action: #selector(clickLeftBtn), for: .touchUpInside)
        leftBtn.setImage(UIImage.init(name: "watch-cover-arrow-left@2x", type: "png"), for: .normal)
        naviBar.addSubview(leftBtn)
    }
    
    @objc open func clickRightBtn() {
        
    }
    @objc open func clickLeftBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    public func hiddenLeftBtn() {
        leftBtn.removeFromSuperview()
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
