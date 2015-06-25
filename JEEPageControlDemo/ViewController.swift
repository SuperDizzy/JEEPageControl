//
//  ViewController.swift
//  JEEPageControlDemo
//
//  Created by ZhangJunjee on 15/6/25.
//  Copyright (c) 2015年 junjeez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var scrollView: UIScrollView!
    var pageControl: JEEPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.pagingEnabled = true
        self.scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * 4, scrollView.bounds.size.height)
        self.view.addSubview(self.scrollView)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        let item = JEEPageItem(pageNum: 4)
        self.pageControl = JEEPageControl(item: item, scrollView: self.scrollView)
        
        self.pageControl.frame = CGRectMake(self.view.frame.width/2-55, 41/48*self.view.frame.height, 120, 24)
        self.view.addSubview(pageControl)
        self.pageControl.currentPage = 1
        for var i=0; i<4; i++ {
            let pageFrame = CGRectMake(CGFloat(i) * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)
            let imageView = UIImageView(frame: pageFrame)
            imageView.image = UIImage(named: "\(i+1)")
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.scrollView.addSubview(imageView)
        }
    }
}

