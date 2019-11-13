//
//  GestureObject.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

final class GestureObject: NSObject {

    enum TouchFlag {
        case touchTopLeft
        case touchTopRight
        case touchSideLeft
        case touchTop
        case touchDown
        case touchBottomLeft
        case touchBottomRight
        case touchSideRight
        case touchNone
    }

    var framePoint  = CGPoint()
    var endPoint    = CGPoint()
    var endFrame    = CGRect()
    var timer       = Timer()
    var timerFlag   = Bool()
    var touchFlag   = TouchFlag.touchBottomRight

    var imageView   : UIImageView?
    var cALayerView : CALayerView?
    var lineDashView: LineDashView?

    private var originY = CGFloat()
    private var originX = CGFloat()
    private var magnification: CGFloat = 2
    
    override init(){
        imageView    = UIImageView()
        cALayerView  = CALayerView()
        lineDashView = LineDashView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func cropEdgeForPoint(point: CGPoint) -> TouchFlag {
        //タップした領域を取得
        guard let frame = lineDashView?.frame else { return .touchNone}
        var topLeftRect: CGRect = frame
        topLeftRect.size.height = CGFloat(64)
        topLeftRect.size.width = CGFloat(64)

        if topLeftRect.contains(point) {
            return TouchFlag.touchTopLeft
        }

        var topRightRect = topLeftRect
        topRightRect.origin.x = frame.maxX - CGFloat(64)
        if topRightRect.contains(point) {
            return TouchFlag.touchTopRight
        }

        var bottomLeftRect = topLeftRect
        bottomLeftRect.origin.y = frame.maxY - CGFloat(64)
        if bottomLeftRect.contains(point) {
            return TouchFlag.touchBottomLeft
        }

        var bottomRightRect = topRightRect
        bottomRightRect.origin.y = bottomLeftRect.origin.y
        if bottomRightRect.contains(point) {
            return TouchFlag.touchBottomRight
        }

        var topRect = frame
        topRect.size.height = CGFloat(64)
        if topRect.contains(point) {
            return TouchFlag.touchTop
        }

        var bottomRect = frame
        bottomRect.origin.y = frame.maxY - CGFloat(64)
        if bottomRect.contains(point) {
            return TouchFlag.touchDown
        }

        var leftRect = frame
        leftRect.size.width =  CGFloat(64)
        if leftRect.contains(point) {
            return TouchFlag.touchSideLeft
        }

        var rightRect = leftRect
        rightRect.origin.x = frame.maxX  - CGFloat(64)
        if rightRect.contains(point) {
            return TouchFlag.touchSideRight
        }
        return TouchFlag.touchNone
    }
    //タップされた領域からMaskするViewのサイズ、座標計算
    func updatePoint(point: CGPoint, touchFlag: TouchFlag)  {
        guard let lineDashView = lineDashView, let imageView = imageView else { return }
        switch touchFlag {
        case .touchNone:break
        case .touchSideRight:
            if endPoint.y != 0 {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x + endFrame.minX
            } else {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x
            }
            break
        case .touchBottomRight:
            if endPoint.y != 0 {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x + endFrame.minX
                lineDashView.frame.size.height =  -point.y + endPoint.y
                lineDashView.frame.origin.y = endPoint.y
            } else {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x
                lineDashView.frame.origin.y =  point.y
                lineDashView.frame.size.height = -(point.y - 60)
            }
            break
        case .touchBottomLeft:
            if endPoint.y != 0 {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x + endFrame.maxX
                lineDashView.frame.size.height =  -point.y + endPoint.y
                lineDashView.frame.origin.y = endPoint.y
            } else {
                lineDashView.frame.origin.x =  point.x
                lineDashView.frame.size.width =  -point.x + imageView.frame.width
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height = -(point.y - 60)
            }
            break
        case .touchTop:
            if endPoint.y != 0 {
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height =  -point.y + endFrame.maxY
            } else {
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height = -point.y + lineDashView.screenWidth + 60
            }
            break
        case .touchDown:
            if endPoint.y != 0 {
                lineDashView.frame.size.height =  -point.y + endPoint.y
                lineDashView.frame.origin.y = endPoint.y
            } else {
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height = -(point.y - 60)
            }
            break
        case .touchSideLeft:
            if endPoint.y != 0 {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x + endFrame.maxX
            } else {
                lineDashView.frame.origin.x =  point.x
                lineDashView.frame.size.width =  -point.x + imageView.frame.width
            }
            break
        case .touchTopRight:
            if endPoint.y != 0 {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x + endFrame.minX
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height =  -point.y + endFrame.maxY
            } else {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height = -point.y + lineDashView.screenWidth + 60
            }
        case .touchTopLeft:
            if endPoint.y != 0 {
                lineDashView.frame.origin.x = point.x
                lineDashView.frame.size.width = -point.x + endFrame.maxX
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height =  -point.y + endFrame.maxY
            } else {
                lineDashView.frame.origin.x =  point.x
                lineDashView.frame.size.width =  -point.x + imageView.frame.width
                lineDashView.frame.origin.y = point.y
                lineDashView.frame.size.height = -point.y + lineDashView.screenWidth + 60
                break
            }
        }
        let kTOCropViewMinimumBoxSize = 44
        // フォーカスの最小枠と最大枠
        let minSize = CGSize(width: kTOCropViewMinimumBoxSize, height: kTOCropViewMinimumBoxSize)
        let maxSize = CGSize(width: lineDashView.frame.maxX, height: lineDashView.frame.maxY)
        lineDashView.frame.size.width  = max(lineDashView.frame.size.width, minSize.width)
        lineDashView.frame.size.height  = max(lineDashView.frame.size.height, minSize.height)
        
        lineDashView.frame.size.width  = min(lineDashView.frame.size.width, maxSize.width)
        lineDashView.frame.size.height  = min(lineDashView.frame.size.height, maxSize.height)
        
        lineDashView.frame.origin.x  = max(lineDashView.frame.origin.x, lineDashView.frame.minX)
        lineDashView.frame.origin.x = min(lineDashView.frame.origin.x, lineDashView.frame.maxX - minSize.width)
        
        lineDashView.frame.origin.y  = max(lineDashView.frame.origin.y, lineDashView.frame.minY)
        lineDashView.frame.origin.y  = min(lineDashView.frame.origin.y, lineDashView.frame.maxY - minSize.height)
        
    }

    //フォーカスの形により座標、サイズの設定のメソッド呼び出し
    func matchGround() {
        guard let lineDashView = lineDashView else { return }
        let sizeSet = lineDashView.frame.size
        
        guard (sizeSet.width / sizeSet.height) < 0.5 && 1.5 < (sizeSet.width / sizeSet.height) else {
            originalScale()
            return
        }

        guard (sizeSet.width / sizeSet.height) > 0.7 || 1.45 > (sizeSet.width / sizeSet.height) else {
            if lineDashView.frame.height > lineDashView.frame.width {
                matchVertical()
            } else {
                originalScale()
            }
            return
        }
         originalScale(centerOrigin: 30)
    }
    

    func matchVertical(){
        guard let lineDashView = lineDashView, let imageView = imageView, let cALayerView = cALayerView else { return }
        if lineDashView.frame.size.width < lineDashView.openImageView.frame.width/5 {
            self.magnification = 6.5
        } else if lineDashView.frame.size.width < lineDashView.openImageView.frame.width/4 {
            self.magnification = 3.5
        }else if lineDashView.frame.size.width < lineDashView.openImageView.frame.width/3 {
            self.magnification = 3
        } else if lineDashView.frame.size.width < lineDashView.openImageView.frame.width/2 {
            self.magnification = 2
        } else if imageView.frame.size.width > lineDashView.openImageView.frame.width {
            self.magnification = 2.5
        } else {
            self.originY = 1.0
            self.originX = 1.0
            self.magnification = 1.0
        }
        self.originY = lineDashView.openImageView.frame.height/lineDashView.frame.size.height
        self.originX = lineDashView.openImageView.frame.width/lineDashView.frame.size.width
        
        imageView.frame.size.width = imageView.frame.width * self.originX/self.magnification
        imageView.frame.size.height = imageView.frame.height * self.originX/self.self.magnification
        
        lineDashView.frame.size.width = lineDashView.frame.size.width * self.originX/self.magnification
        lineDashView.frame.size.height = lineDashView.frame.height * self.originX/self.magnification
        
        let centerY = lineDashView.openImageView.frame.size.height/2 - lineDashView.frame.size.height/2
        let centerX = lineDashView.openImageView.frame.size.width/2 - lineDashView.frame.size.width/2
        
        imageView.frame.origin.x = -lineDashView.frame.origin.x*self.originX/self.magnification + imageView.frame.origin.x*self.originX/self.magnification + centerX
        imageView.frame.origin.y = -lineDashView.frame.origin.y*self.originX/self.magnification + imageView.frame.origin.y*self.originX/self.magnification + centerY
        lineDashView.frame.origin.x = centerX
        lineDashView.frame.origin.y = centerY
        
        cALayerView.hollowTargetLayer?.backgroundColor = UIColor.clear.cgColor
        lineDashView.isHidden = true
        cALayerView.gridHideen(true)
    }
    
    func originalScale(centerOrigin: CGFloat? = nil) {
        guard let lineDashView = lineDashView, let imageView = imageView, let cALayerView = cALayerView else { return }
        self.originY = lineDashView.openImageView.frame.height/lineDashView.frame.size.height
        self.originX = lineDashView.openImageView.frame.width/lineDashView.frame.size.width
        imageView.frame.size.width = imageView.frame.width * self.originX
        lineDashView.frame.size.width = lineDashView.openImageView.frame.size.width
        lineDashView.frame.size.height = lineDashView.frame.size.height * self.originX
        imageView.frame.size.height = imageView.frame.height * self.originX

        let centerY = lineDashView.openImageView.frame.size.height/2 - lineDashView.frame.size.height/2
        let centerX = lineDashView.openImageView.frame.size.width/2 - lineDashView.frame.size.width/2

        imageView.frame.origin.x = -lineDashView.frame.origin.x*self.originX + imageView.frame.origin.x*self.originX + centerX
        imageView.frame.origin.y = -lineDashView.frame.origin.y*self.originX + imageView.frame.origin.y*self.originX + centerY + (centerOrigin ?? CGFloat())
        lineDashView.frame.origin.y = centerY + (centerOrigin ?? CGFloat())
        lineDashView.frame.origin.x = centerX

        cALayerView.hollowTargetLayer?.backgroundColor = UIColor.clear.cgColor
        lineDashView.isHidden = true
        cALayerView.gridHideen(true)
        }
}
