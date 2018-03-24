//
//  MessageAlbumView.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/7.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

class MessageAlbumView: UIView, UIScrollViewDelegate {
    
    
    var imagesList: [MessageModel]?
    var index = 0
    let scrollView = UIScrollView()
    var imageDic = [Int: MessageScrollView]()
    
    var rect = CGRect.zero
    
    static let Default = MessageAlbumView()
    
    
    fileprivate convenience init() {
        self.init(frame: kWindow!.bounds)
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.frame = frame
        scrollView.backgroundColor = backgroundColor
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        
        scrollView.delegate = self
        
        
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func clear() {
        Default.scrollView.removeAllSubviews()
        Default.imagesList?.removeAll()
        Default.imageDic.removeAll()
    }
    
    class func show(imagesList: [MessageModel], rect: CGRect, index: Int) {
        Default.backgroundColor = UIColor.black

        kWindow?.addSubview(Default)
        
        Default.rect = rect
        Default.imagesList = imagesList
        Default.index = index
        
        Default.scrollView.contentSize = CGSize.init(width: kScreenWidth * CGFloat(imagesList.count), height: kScreenHeight)
        Default.scrollView.contentOffset = CGPoint.init(x: kScreenWidth * CGFloat(index), y: 0)
        
        var indexArray = [Int]()
        
        if imagesList.count < 3 {
            for i in 0..<imagesList.count {
                indexArray.append(i)
            }
        } else {
            if index == 0 {
                indexArray = [0,1,2]
            } else if index == imagesList.count - 1 {
                indexArray = [index - 2,index - 1,index]
            } else {
                indexArray = [index - 1,index,index + 1]
            }
        }
        if Default.imageDic.count == indexArray.count {
            var oldImageViewList = [MessageScrollView]()
            for (_,value) in Default.imageDic {
                oldImageViewList.append(value)
            }
            Default.imageDic.removeAll()
            
            var i = 0
            for index in indexArray {
                Default.imageDic[index] = oldImageViewList[i]
                i += 1
            }
        }
        
        for i in indexArray {
            let model = imagesList[i]
            let scrollView = Default.getScrollView(index: i)
            let frame = CGRect.init(x: kScreenWidth * CGFloat(i), y: 0, width: kScreenWidth, height: kScreenHeight)
            scrollView.frame = frame
            scrollView.imageView.frame = scrollView.bounds
            scrollView.imageView.image = model.image
            Default.resetImageViewFrame(scrollView: scrollView)

            
            if i == index {
                scrollView.imageView.frame = rect
                UIView.animate(withDuration: 0.3) {
                    scrollView.imageView.frame = scrollView.bounds
                }
            }
        }
    }
    
    
    // MARK: - Handle ImageView
    
    func getScrollView(index: Int) -> MessageScrollView {
        if let imageView = imageDic[index] {
            return imageView
        }
        return createScrollView(index: index)
    }
    
    func createScrollView(index: Int) -> MessageScrollView {
        let scrollView = MessageScrollView()
        self.scrollView.addSubview(scrollView)
        imageDic[index] = scrollView

        let imageView = UIImageView.init()
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
//        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        scrollView.imageView = imageView

        let tap = UITapGestureRecognizer.init(actionBlock: { [weak self] _ in
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.zoomScale = 1
                imageView.frame = self!.rect
            }, completion: { _ in
                imageView.image = nil
                self?.removeFromSuperview()
            })
        })
        scrollView.addGestureRecognizer(tap)
        
        
        return scrollView
    }
    
    
    func exchangeImageView(from: Int, to: Int) {

        let scrollView = getScrollView(index: from)
        imageDic.removeValue(forKey: from)
        imageDic[to] = scrollView
        
        scrollView.left = kScreenWidth * CGFloat(to)
        let model = imagesList![to]
        scrollView.imageView.image = model.image
        resetImageViewFrame(scrollView: scrollView)
    }
    
    func resetScale() {
        let scrollView = getScrollView(index: index)
        scrollView.zoomScale = 1
    }
    
    func resetImageViewFrame(scrollView: MessageScrollView)  {
        if let size = scrollView.imageView.image?.size {
            var width = scrollView.width
            var height = scrollView.height
            
            if size.width / size.height > scrollView.width / scrollView.height {
                width = scrollView.width
                height = scrollView.width * size.height / size.width
            } else if size.width / size.height < scrollView.width / scrollView.height {
                width = scrollView.height * size.width / size.height
                height = scrollView.height
            }
            
            scrollView.imageView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
            scrollView.imageView.center = CGPoint.init(x: scrollView.width / 2, y: scrollView.height / 2)
        }
    }
   
    
    // MARK: - ScrollView Delegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        let nextIndex = Int(scrollView.contentOffset.x / kScreenWidth)
        if nextIndex != index {
            resetScale()
        }
        if nextIndex == 0 || nextIndex == imagesList!.count - 1 {
            index = nextIndex
            return
        }
        if index == 0 || index == imagesList!.count - 1 {
            index = nextIndex
            return
        }
        if index - nextIndex < 0 {
            exchangeImageView(from: index - 1, to: nextIndex + 1)
        } else if index - nextIndex > 0 {
            exchangeImageView(from: index + 1, to: nextIndex - 1)
        }
        index = nextIndex
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.isUserInteractionEnabled = false
    }
    
    
}

class MessageScrollView: UIScrollView, UIScrollViewDelegate {
    var imageView = UIImageView()
   
    fileprivate convenience init() {
        self.init(frame: kWindow!.bounds)
    }
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentSize = CGSize.init(width: kScreenWidth, height: kScreenHeight)
        isDirectionalLockEnabled = true
        
        delegate = self
        maximumZoomScale = 2
        minimumZoomScale = 1
        zoomScale = 1
        
        clipsToBounds = true
        bounces = false
        
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = CGPoint.init(
            x: max(width, scrollView.contentSize.width) / 2,
            y: max(height, scrollView.contentSize.height) / 2
        )
    }
  
    

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
