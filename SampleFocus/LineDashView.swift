//
//  LineDashView.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

final class LineDashView: UIView {

    lazy var openImageView: UIImageView = {
        let openImageView = UIImageView()
        return openImageView
    }()

    private var screenHeight = UIScreen.main.bounds.height - 15
    private var screenWidth  = UIScreen.main.bounds.width
    private var xWidth                        : CGFloat = 5
    private var yHeight                       : CGFloat = 5
    private var editing                       = Bool()
    private var applyInitialCroppedImageFrame = Bool()
    private var cropBoxFrame                  : CGRect?
    private var lineColor                     : UIBezierPath?
    private var lineColor2                    : UIBezierPath?
    private var lineColor3                    : UIBezierPath?
    private var lineColor4                    : UIBezierPath?
    private var borderView                    : UIView?


    override init(frame: CGRect) {
        super.init(frame: .zero)

        cropBoxFrame                  = CGRect()
        lineColor                     = UIBezierPath()
        lineColor2                    = UIBezierPath()
        lineColor3                    = UIBezierPath()
        lineColor4                    = UIBezierPath()
        borderView                    = UIView()

        self.backgroundColor = .clear
        self.frame = CGRect(x: xWidth, y: yHeight, width: screenWidth, height: screenHeight)
        openImageView.frame = CGRect(x: xWidth, y:yHeight, width: screenWidth, height: screenHeight)
        addSubview(openImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        borderView?.layer.borderColor = UIColor.white.cgColor
        borderView?.layer.borderWidth =  1
    }

    override func draw(_ rect: CGRect) {
        //フォーカス内の罫線の設定
        var i: CGFloat = screenHeight
        i -= screenHeight / 3
        lineColor?.move(to: CGPoint(x:screenWidth, y: i*0.5))
        lineColor?.addLine(to: CGPoint(x: 0 , y: i*0.5))
        UIColor.white.setStroke()
        lineColor?.stroke()

        lineColor2?.move(to: CGPoint(x:screenWidth, y: i))
        lineColor2?.addLine(to: CGPoint(x: 0 , y: i))
        UIColor.white.setStroke()
        lineColor2?.stroke()

        var i3: CGFloat = screenWidth
        i3 = screenWidth / 3
        lineColor3?.move(to: CGPoint(x:i3, y: 0))
        lineColor3?.addLine(to: CGPoint(x: i3 , y: screenHeight))
        UIColor.white.setStroke()
        lineColor3?.stroke()

        lineColor4?.move(to: CGPoint(x:i3*2, y: 0))
        lineColor4?.addLine(to: CGPoint(x: i3*2 , y: screenHeight))
        UIColor.white.setStroke()
        lineColor4?.stroke()
    }

}
