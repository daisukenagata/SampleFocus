//
//  PanGestureView.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2019/03/24.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit

struct CommonStructure { static var swipePanGesture = UIPanGestureRecognizer() }

final class PanGestureView: UIView, UIGestureRecognizerDelegate { 

    var cALayerView = CALayerLogic()
    var lineDashView = LineDashView()
    var gestureObject = GestureObject()
    var touchFlag = TouchFlag.touchSideLeft

    let vcs = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.frame = UIScreen.main.bounds
        self.addSubview(vcs)

        // ジャスチャーx
        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self
        
        self.addGestureRecognizer( CommonStructure.swipePanGesture)
        self.backgroundColor = .blue
        
        // レイヤーのマスキング
        cALayerView.tori(views: lineDashView)
        
        vcs.layer.addSublayer(cALayerView.hollowTargetLayer)
        vcs.addSubview(lineDashView)
        lineDashView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: self)
        //指が離れた際の座標を取得
        self.gestureObject.endPoint = self.lineDashView.frame.origin
        self.gestureObject.endFrame = self.lineDashView.frame
        self.cALayerView.tori(views: lineDashView)
        
        switch sender.state {
        case .ended:
            break
        case .possible:
            break
        case .began:
            lineDashView.isHidden = false
            //タップした領域を取得
            touchFlag = self.gestureObject.cropEdgeForPoint(point: gestureObject.framePoint, views: vcs)
            break
        case .changed:
            //タップされた領域からMaskするViewのサイズ、座標計算
            self.gestureObject.updatePoint(point: position,views: lineDashView,touchFlag: self.touchFlag)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position: CGPoint = touch.location(in: self)
        gestureObject.framePoint = position
        return true
    }
}
