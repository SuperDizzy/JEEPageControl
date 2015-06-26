//
//  JEEPageControl.swift
//  yuguo
//
//  Created by ZhangJunjee on 15/6/8.
//  Copyright (c) 2015年 yuguo. All rights reserved.
//

import UIKit

class JEEPageControl: UIControl, UIScrollViewDelegate {
    struct pageStatic {
        static let kDotDiameterOn:CGFloat = 24
        static let kDotDiameterOff:CGFloat = 14
        static let kDotSpace:CGFloat = 18
    }
    var pageItem: JEEPageItem!
    var pageScrollView: UIScrollView!
    var currentPage: Int = 1
    
    private var dotArray = [UIView]()
    private var isClickJump = false
    
    init(item: JEEPageItem!, scrollView: UIScrollView!) {
        super.init(frame: CGRectZero)
        self.pageItem = item
        self.pageScrollView = scrollView
        self.pageScrollView.delegate = self
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initDotSize() {
        for dotView in self.dotArray {
            dotView.transform = CGAffineTransformIdentity
            dotView.backgroundColor = self.pageItem.offColor
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.size.width
        var fractional = fabs((scrollView.contentOffset.x % pageWidth)/pageWidth)
        var forward = false
        if scrollView.contentOffset.x >= CGFloat(self.currentPage - 1) * pageWidth {
            forward = true
        }else {
            if scrollView.contentOffset.x > 0 {
                fractional = 1-fractional
            }
        }
        self.changeToNearDot(forward, progress: fractional)
        let fractionalPage = scrollView.contentOffset.x / pageWidth + 1
        self.currentPage = lround(Double(fractionalPage))
    }
    
    func setupView() {
        var diameter = self.pageItem.indicatorDiameterOff
        if diameter <= 0 {
            diameter = pageStatic.kDotDiameterOff
        }
        
        var space = self.pageItem.indicatorSpace
        if space <= 0 {
            diameter = pageStatic.kDotSpace
        }
        var offColor = self.pageItem.offColor
        var onColor = self.pageItem.onColor
        
        for var i=0; i<self.pageItem.numberOfPages; i++ {
            
            var dotView = UIView(frame: CGRectMake(CGFloat(i)*diameter+CGFloat(i)*space, 0, diameter, diameter))
            dotView.layer.cornerRadius = diameter/2
            dotView.backgroundColor = offColor
            dotView.tag = i+1
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: "tapDotView:")
            dotView.addGestureRecognizer(tapGesture)
            self.addSubview(dotView)
            self.dotArray.append(dotView)
        }
        if self.pageItem.numberOfPages > 0 {
            var bigTransform = self.pageItem.indicatorDiameterOn/self.pageItem.indicatorDiameterOff
            self.dotArray[0].transform = CGAffineTransformMakeScale(bigTransform, bigTransform)
            self.dotArray[0].backgroundColor = onColor
        }
    }
    
    func tapDotView(gesture: UITapGestureRecognizer) {
        self.isClickJump = true
        let dotView = gesture.view!
        let pageWidth = self.pageScrollView.bounds.size.width * CGFloat(dotView.tag - 1)
        self.pageScrollView.scrollRectToVisible(CGRectMake(pageWidth, self.pageScrollView.frame.origin.y, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height), animated: true)
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    func changeToNearDot(forward: Bool, progress: CGFloat) {
        var toDotView: UIView?
        if forward&&self.currentPage < self.dotArray.count {
            toDotView = self.dotArray[self.currentPage]
        }else if !forward&&self.currentPage > 1 {
            toDotView = self.dotArray[self.currentPage - 2]
        }
        var fromDotView = self.dotArray[self.currentPage - 1]
        var diffTransform = (self.pageItem.indicatorDiameterOn - self.pageItem.indicatorDiameterOff)/self.pageItem.indicatorDiameterOff

        if progress > 0 && progress < 1 {
            var offColor = self.pageItem.offColor
            var onColor = self.pageItem.onColor
            if toDotView != nil {
                toDotView!.transform = CGAffineTransformMakeScale(1+diffTransform*progress, 1+diffTransform*progress)
                
                toDotView?.backgroundColor = self.colorTransformToAnother(offColor, toColor: onColor, progress: progress)
            }
            fromDotView.transform = CGAffineTransformMakeScale((1 + diffTransform)-diffTransform*progress, (1 + diffTransform)-diffTransform*progress)
            fromDotView.backgroundColor = self.colorTransformToAnother(onColor, toColor: offColor, progress: progress)
        }
    }
    
    func colorTransformToAnother(fromColor: UIColor, toColor: UIColor, progress: CGFloat) -> UIColor {
        let fromRGB = CGColorGetComponents(fromColor.CGColor)
        let toRGB = CGColorGetComponents(toColor.CGColor)
        return UIColor(red: fromRGB[0] + (toRGB[0] - fromRGB[0])*progress, green: fromRGB[1] + (toRGB[1] - fromRGB[1])*progress, blue: fromRGB[2] + (toRGB[2] - fromRGB[2])*progress, alpha: fromRGB[3] + (toRGB[3] - fromRGB[3])*progress)
    }
}

class JEEPageItem {
    var numberOfPages: Int!
    var onColor: UIColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    var offColor: UIColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 0.4)
    var indicatorDiameterOn: CGFloat = 24
    var indicatorDiameterOff: CGFloat = 14
    var indicatorSpace: CGFloat = 18
    var hideForSignlePage: Bool = true
    
    init(pageNum: Int) {
        self.numberOfPages = pageNum
    }
}
