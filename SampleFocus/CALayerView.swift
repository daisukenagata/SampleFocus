//
//  CALayerView.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

class CALayerLogic {

    var path =  UIBezierPath()
    let maskLayer = CAShapeLayer()
    let hollowTargetLayer = CALayer()

    func tori(views: UIView){
        views.layer.borderWidth = 1
        views.layer.borderColor = UIColor.white.cgColor
        hollowTargetLayer.bounds = UIScreen.main.bounds
        hollowTargetLayer.frame.size.height = views.frame.height
        hollowTargetLayer.position = CGPoint(
            x: hollowTargetLayer.frame.width / 2.0,
            y: (hollowTargetLayer.bounds.height) / 2.0
        )

        hollowTargetLayer.backgroundColor = UIColor.black.cgColor
        hollowTargetLayer.opacity = 0.7

        maskLayer.bounds = hollowTargetLayer.bounds

        path =  UIBezierPath.init(rect: views.frame)
        path.append(UIBezierPath(rect: maskLayer.bounds))

        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        maskLayer.position = CGPoint(
            x: hollowTargetLayer.bounds.width / 2.0,
            y: (hollowTargetLayer.bounds.height / 2.0)
        )

        maskLayer.fillRule = kCAFillRuleEvenOdd
        hollowTargetLayer.mask = maskLayer

    }
}
