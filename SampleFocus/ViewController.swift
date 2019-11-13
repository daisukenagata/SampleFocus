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

    var gestureObject = GestureObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        // ジャスチャー
        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self

        view.addGestureRecognizer( CommonStructure.swipePanGesture)
        view.backgroundColor = .blue
        
        gestureObject.imageView.image = UIImage(named: "Mac")
        gestureObject.imageView.contentMode = .scaleAspectFit
        gestureObject.imageView.frame = CGRect(x: 30, y: 30, width: view.frame.width - 60, height: view.frame.height - 30)
        view.addSubview(gestureObject.imageView)
        // レイヤーのマスキング
        gestureObject.cALayerView.tori(gesture: gestureObject, bool: true)
        
        view.layer.addSublayer(gestureObject.cALayerView.hollowTargetLayer)
        view.addSubview(gestureObject.cALayerView)
        
        view.addSubview(gestureObject.lineDashView)
        gestureObject.lineDashView.isHidden = true
    }

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: view)
        //画面をなぞる場合にフォーカスの設定
        self.gestureObject.cALayerView.effect(gesture: gestureObject, bool: true, boolSecound: true)
        self.gestureObject.cALayerView.tori(gesture: gestureObject, bool: false)
        switch sender.state {
        case .ended:
            //指が離れた際の座標を取得
            gestureObject.endPoint = gestureObject.lineDashView.frame.origin
            gestureObject.endFrame = gestureObject.lineDashView.frame
            //フォーカス計算のメソッド呼び出し
            gestureObject.timerFlag = false
            timerSetting()
            break
        case .possible:
            break
        case .began:
            gestureObject.lineDashView.isHidden = false
            gestureObject.timerFlag = true
            gestureObject.timer.invalidate()
            //タップした領域を取得
            gestureObject.touchFlag = self.gestureObject.cropEdgeForPoint(point: gestureObject.framePoint)
            break
        case .changed:
             //タップされた領域からMaskするViewのサイズ、座標計算
            self.gestureObject.updatePoint(point: position,views: self,touchFlag: self.gestureObject.touchFlag)
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            fatalError()
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position: CGPoint = touch.location(in: view)
        gestureObject.framePoint = position
        return true
    }

    func timerSetting() {
        gestureObject.timer = Timer.scheduledTimer(timeInterval:3.0,
                                     target: self,
                                     selector: #selector(animetionSet),
                                     userInfo: nil,
                                     repeats: false)
    }

    @objc func animetionSet() {
        if gestureObject.timerFlag == false {
            gestureObject.matchGround(imageView: gestureObject.imageView)
            gestureObject.timerFlag = true
            gestureObject.timer.invalidate()
        }
    }
}
