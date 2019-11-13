//
//  CALayerView.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

final class CALayerView: UIView {

    var hollowTargetLayer: CALayer?

    private var path     :  UIBezierPath?
    private var maskLayer: CAShapeLayer?

    private let girdViewLeftTopWidth      = UIView()
    private let girdViewLeftUpRightHeight = UIView()
    private let girdViewLeftDownWidth     = UIView()
    private let girdViewLeftDownHeight    = UIView()
    private let girdViewRightUpWidth      = UIView()
    private let girdViewRightUpHeight     = UIView()
    private let girdViewRightDownWidth    = UIView()
    private let girdViewRightDownHeight   = UIView()
    private let width : CGFloat = 20
    private let height: CGFloat = 22
    private let wide  : CGFloat = 2


    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.frame = UIScreen.main.bounds
        self.frame.size.height = UIScreen.main.bounds.height - 44
        self.addSubview(girdViewLeftTopWidth)
        self.addSubview(girdViewLeftUpRightHeight)
        self.addSubview(girdViewLeftDownWidth)
        self.addSubview(girdViewLeftDownHeight)
        self.addSubview(girdViewRightUpWidth)
        self.addSubview(girdViewRightUpHeight)
        self.addSubview(girdViewRightDownWidth)
        self.addSubview(girdViewRightDownHeight)
        
        hollowTargetLayer = CALayer()
        maskLayer         = CAShapeLayer()
        path              =  UIBezierPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func tori(_ gesture: GestureObject,bool: Bool){

        guard   let lineDashView = gesture.lineDashView,
                let hollowTargetLayer = hollowTargetLayer,
                let maskLayer = maskLayer
            else { return }

        lineDashView.layer.borderWidth = 1
        lineDashView.layer.borderColor = UIColor.white.cgColor
        hollowTargetLayer.bounds = self.bounds
        hollowTargetLayer.frame.size.height = UIScreen.main.bounds.height
        hollowTargetLayer.position = CGPoint(
            x: self.bounds.width / 2.0,
            y: (UIScreen.main.bounds.height) / 2.0
        )

        hollowTargetLayer.backgroundColor = UIColor.black.cgColor
        hollowTargetLayer.opacity = 0.7

        maskLayer.bounds = hollowTargetLayer.bounds

        path =  UIBezierPath.init(rect: gesture.lineDashView?.frame ?? CGRect())
        path?.append(UIBezierPath(rect: maskLayer.bounds))

        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path?.cgPath
        maskLayer.position = CGPoint(
            x: hollowTargetLayer.bounds.width / 2.0,
            y: (hollowTargetLayer.bounds.height / 2.0)
        )

        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        hollowTargetLayer.mask = maskLayer

        //角のUI設定
        girdViewLeftTopWidth.backgroundColor = UIColor.white
        girdViewLeftTopWidth.frame = CGRect(x: lineDashView.frame.origin.x, y: lineDashView.frame.origin.y-wide, width: width, height: wide)

        girdViewLeftUpRightHeight.backgroundColor = UIColor.white
        girdViewLeftUpRightHeight.frame = CGRect(x: lineDashView.frame.origin.x-wide, y: lineDashView.frame.origin.y-wide, width: wide, height: height)

        girdViewLeftDownWidth.backgroundColor = UIColor.white
        girdViewLeftDownWidth.frame = CGRect(x: lineDashView.frame.origin.x, y: lineDashView.frame.height+lineDashView.frame.origin.y, width: width, height: wide)

        girdViewLeftDownHeight.backgroundColor = UIColor.white
        girdViewLeftDownHeight.frame = CGRect(x: lineDashView.frame.origin.x-wide, y: lineDashView.frame.height+lineDashView.frame.origin.y-width, width: wide, height: height)

        girdViewRightUpWidth.backgroundColor = UIColor.white
        girdViewRightUpWidth.frame = CGRect(x: lineDashView.frame.width + lineDashView.frame.origin.x-width , y: lineDashView.frame.origin.y-wide, width: width, height: wide)

        girdViewRightUpHeight.backgroundColor = UIColor.white
        girdViewRightUpHeight.frame = CGRect(x: lineDashView.frame.width + lineDashView.frame.origin.x, y: lineDashView.frame.origin.y-wide, width: wide, height: height)

        girdViewRightDownWidth.backgroundColor = UIColor.white
        girdViewRightDownWidth.frame = CGRect(x: lineDashView.frame.width + lineDashView.frame.origin.x-width, y: lineDashView.frame.height+lineDashView.frame.origin.y, width: width, height: wide)

        girdViewRightDownHeight.backgroundColor = UIColor.white
        girdViewRightDownHeight.frame = CGRect(x: lineDashView.frame.width + lineDashView.frame.origin.x, y: lineDashView.frame.height+lineDashView.frame.origin.y-width, width: wide, height: height)
 
        girdViewLeftTopWidth.isHidden = bool
        girdViewLeftUpRightHeight.isHidden = bool
        girdViewLeftDownWidth.isHidden = bool
        girdViewLeftDownHeight.isHidden = bool
        girdViewRightUpWidth.isHidden = bool
        girdViewRightUpHeight.isHidden = bool
        girdViewRightDownWidth.isHidden = bool
        girdViewRightDownHeight.isHidden = bool

    }

    func gridHideen(_ bool: Bool) {
        girdViewLeftTopWidth.isHidden = bool
        girdViewLeftUpRightHeight.isHidden = bool
        girdViewLeftDownWidth.isHidden = bool
        girdViewLeftDownHeight.isHidden = bool
        girdViewRightUpWidth.isHidden = bool
        girdViewRightUpHeight.isHidden = bool
        girdViewRightDownWidth.isHidden = bool
        girdViewRightDownHeight.isHidden = bool
    }

    func effect(_ gesture: GestureObject, bool: Bool){

        guard let hollowTargetLayer = hollowTargetLayer, let maskLayer = maskLayer else { return }

        guard let lineDashView = gesture.lineDashView else { return }
        gesture.lineDashView?.layer.borderWidth = 1
        gesture.lineDashView?.layer.borderColor = UIColor.white.cgColor

        hollowTargetLayer.bounds = self.bounds
        hollowTargetLayer.frame.size.height = UIScreen.main.bounds.height
        hollowTargetLayer.position = CGPoint(
            x: self.bounds.width / 2.0,
            y: (UIScreen.main.bounds.height) / 2.0
        )
        // 四角いマスクレイヤーを作る
        maskLayer.bounds = hollowTargetLayer.bounds

        path =  UIBezierPath.init(rect: lineDashView.frame)
        path?.append(UIBezierPath(rect: maskLayer.bounds))

        maskLayer.path = path?.cgPath
        maskLayer.position = CGPoint(
            x: hollowTargetLayer.bounds.width / 2.0,
            y: (hollowTargetLayer.bounds.height / 2.0)
        )
        // マスクのルールをeven/oddに設定する
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        //マスキング箇所の設定
        hollowTargetLayer.mask = maskLayer

        let blurView = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurView)

        effectView.frame = hollowTargetLayer.frame
        effectView.layer.mask = maskLayer
        effectView.isHidden = bool
    }
}
