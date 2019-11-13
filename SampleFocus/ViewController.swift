//
//  ViewController.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var g: GestureView?

    override func viewDidLoad() {
        super.viewDidLoad()
        g = GestureView(view.frame ,imageSt: "Mac")
        view.addSubview(g ?? UIView())
    }
}
