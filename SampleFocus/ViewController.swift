//
//  ViewController.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var g: GestureView?

    override func viewDidLoad() {
        super.viewDidLoad()
        g = GestureView(view.frame ,imageSt: "Mac")
        view.addSubview(g ?? UIView())
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { v in
            self.setView()
        }, completion: nil)
    }

    func setView() {
        self.g?.removeFromSuperview()
        self.g = GestureView(self.view.frame ,imageSt: "Mac")
        self.view.addSubview(self.g ?? UIView())
    }
}
