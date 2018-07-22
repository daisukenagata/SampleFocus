//
//  ViewController.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

struct CommonStructure {
    // ジャスチャー
    static var swipePanGesture = UIPanGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    var timer = Timer()
    var timerFlag = Bool()
    var imageView = UIImageView()
    var cALayerView = CALayerView()
    var lineDashView = LineDashView()
    var gestureObject = GestureObject()
    var touchFlag = TouchFlag.touchBottomRight


    override func viewDidLoad() {
        super.viewDidLoad()
        // ジャスチャー
        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self

        view.addGestureRecognizer( CommonStructure.swipePanGesture)
        view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        imageView.image = UIImage(named: "Mac")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 30, y: 30, width: view.frame.width - 60, height: view.frame.height - 30)
        view.addSubview(imageView)
        // レイヤーのマスキング
        cALayerView.tori(vc: self, bool: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.addSublayer(cALayerView.hollowTargetLayer)
        view.addSubview(cALayerView)
    }
    
    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: view)
        
        //画面をなぞる場合にフォーカスの設定
        DispatchQueue.main.async {
        self.cALayerView.effect(vc: self,bool: true, boolSecound: true)
        self.cALayerView.tori(vc: self, bool: false)
        self.view.addSubview(self.lineDashView)
        }

        switch sender.state {
        case .ended:
            //指が離れた際の座標を取得
            gestureObject.endPoint = lineDashView.frame.origin
            gestureObject.endFrame = lineDashView.frame
            //フォーカス計算のメソッド呼び出し
            timerFlag = false
            timerSetting()
            break
        case .possible:
            break
        case .began:
            lineDashView.isHidden = false
            timerFlag = true
            timer.invalidate()
            //タップした領域を取得
            touchFlag = self.gestureObject.cropEdgeForPoint(point: gestureObject.framePoint, views: self)
            break
        case .changed:
             //タップされた領域からMaskするViewのサイズ、座標計算
            self.gestureObject.updatePoint(point: position,views: self,touchFlag: self.touchFlag)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position: CGPoint = touch.location(in: view)
        gestureObject.framePoint = position
        return true
    }
    func timerSetting() {
        timer = Timer.scheduledTimer(timeInterval:3.0,
                                     target: self,
                                     selector: #selector(animetionSet),
                                     userInfo: nil,
                                     repeats: false)
    }
    @objc func animetionSet() {
        if timerFlag == false {
            gestureObject.matchGround(views: self, imageView: imageView)
            timerFlag = true
            timer.invalidate()
        }
    }
}

