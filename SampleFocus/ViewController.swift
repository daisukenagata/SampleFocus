//
//  ViewController.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UIGestureRecognizerDelegate {

   let v = PanGestureView()

    override func viewDidLoad() {
        super.viewDidLoad()

        v.vcs.backgroundColor = .red
        v.vcs.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 100)
        view.addSubview(v)
    }
}
