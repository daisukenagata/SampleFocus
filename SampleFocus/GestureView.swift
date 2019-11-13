//
//  GestureView.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2019/11/13.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit

final class GestureView: UIView, UIGestureRecognizerDelegate {

    private var gestureObject   = GestureObject()
    private var swipePanGesture = UIPanGestureRecognizer()
    private let margin          : CGFloat = 30
    private let animationTimer  : Double = 3.0

    init(_ frame: CGRect? = nil, imageSt: String? = nil) {
        super.init(frame: frame ?? CGRect())

        initSetting(imageSt: imageSt ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSetting(imageSt: String) {
        // ジャスチャー
        swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        swipePanGesture.delegate = self

        self.addGestureRecognizer( swipePanGesture)
        self.backgroundColor = .blue

        gestureObject.imageView?.image = UIImage(named: imageSt)
        gestureObject.imageView?.contentMode = .scaleAspectFit
        gestureObject.imageView?.frame = CGRect(x: margin, y: margin, width: self.frame.width - margin*2, height: self.frame.height - margin)
        self.addSubview(gestureObject.imageView ?? UIImageView())
        // レイヤーのマスキング
        gestureObject.cALayerView?.tori(gestureObject, bool: true)

        self.layer.addSublayer(gestureObject.cALayerView?.hollowTargetLayer ?? CALayer())
        self.addSubview(gestureObject.cALayerView ?? UIView())

        self.addSubview(gestureObject.lineDashView ?? UIView())
        gestureObject.lineDashView?.isHidden = true
    }
    
    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: self)
        //画面をなぞる場合にフォーカスの設定
        self.gestureObject.cALayerView?.effect(gestureObject, bool: false)
        self.gestureObject.cALayerView?.tori(gestureObject, bool: false)
        switch sender.state {
        case .ended:
            //指が離れた際の座標を取得
            gestureObject.endPoint = gestureObject.lineDashView?.frame.origin ?? CGPoint()
            gestureObject.endFrame = gestureObject.lineDashView?.frame ?? CGRect()
            //フォーカス計算のメソッド呼び出し
            gestureObject.timerFlag = false
            timerSetting()
            break
        case .possible:
            break
        case .began:
            gestureObject.lineDashView?.isHidden = false
            gestureObject.timerFlag = true
            gestureObject.timer.invalidate()
            //タップした領域を取得
            gestureObject.touchFlag = self.gestureObject.cropEdgeForPoint(point: gestureObject.framePoint)
            break
        case .changed:
             //タップされた領域からMaskするViewのサイズ、座標計算
            self.gestureObject.updatePoint(gestureObject.imageView?.frame.height ?? 0.0, point: position,touchFlag: self.gestureObject.touchFlag)
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
        let position: CGPoint = touch.location(in: self)
        gestureObject.framePoint = position
        return true
    }

    func timerSetting() {
        gestureObject.timer = Timer.scheduledTimer(timeInterval:animationTimer,
                                     target: self,
                                     selector: #selector(animetionSet),
                                     userInfo: nil,
                                     repeats: false)
    }

    @objc func animetionSet() {
        if gestureObject.timerFlag == false {
            gestureObject.matchGround()
            gestureObject.timerFlag = true
            gestureObject.timer.invalidate()
        }
    }
}
