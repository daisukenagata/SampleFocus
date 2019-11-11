//
//  GestureObject.swift
//  SampleFocus
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

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

class GestureObject: UIView {

    var framePoint = CGPoint()
    var endPoint = CGPoint()
    var endFrame = CGRect()
    var originY = CGFloat()
    var originX = CGFloat()
    var magnification: CGFloat = 2


    func cropEdgeForPoint(point: CGPoint, views: ViewController) -> TouchFlag {
        //タップした領域を取得
        let frame = views.lineDashView.frame
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
    func updatePoint(point: CGPoint, views: ViewController, touchFlag: TouchFlag)  {

        switch touchFlag {
        case .touchNone:break
        case .touchSideRight:
            if endPoint.y != 0 {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x + endFrame.minX
            } else {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x
            }
            break
        case .touchBottomRight:
            if endPoint.y != 0 {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x + endFrame.minX
                views.lineDashView.frame.size.height =  -point.y + endPoint.y
                views.lineDashView.frame.origin.y = endPoint.y
            } else {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x
                views.lineDashView.frame.origin.y =  point.y
                views.lineDashView.frame.size.height = -(point.y - 60)
            }
            break
        case .touchBottomLeft:
            if endPoint.y != 0 {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x + endFrame.maxX
                views.lineDashView.frame.size.height =  -point.y + endPoint.y
                views.lineDashView.frame.origin.y = endPoint.y
            } else {
                views.lineDashView.frame.origin.x =  point.x
                views.lineDashView.frame.size.width =  -point.x + views.imageView.frame.width
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height = -(point.y - 60)
            }
            break
        case .touchTop:
            if endPoint.y != 0 {
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height =  -point.y + endFrame.maxY
            } else {
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height = -point.y + views.lineDashView.screenWidth + 60
            }
            break
        case .touchDown:
            if endPoint.y != 0 {
                views.lineDashView.frame.size.height =  -point.y + endPoint.y
                views.lineDashView.frame.origin.y = endPoint.y
            } else {
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height = -(point.y - 60)
            }
            break
        case .touchSideLeft:
            if endPoint.y != 0 {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x + endFrame.maxX
            } else {
                views.lineDashView.frame.origin.x =  point.x
                views.lineDashView.frame.size.width =  -point.x + views.imageView.frame.width
            }
            break
        case .touchTopRight:
            if endPoint.y != 0 {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x + endFrame.minX
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height =  -point.y + endFrame.maxY
            } else {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height = -point.y + views.lineDashView.screenWidth + 60
            }
        case .touchTopLeft:
            if endPoint.y != 0 {
                views.lineDashView.frame.origin.x = point.x
                views.lineDashView.frame.size.width = -point.x + endFrame.maxX
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height =  -point.y + endFrame.maxY
            } else {
                views.lineDashView.frame.origin.x =  point.x
                views.lineDashView.frame.size.width =  -point.x + views.imageView.frame.width
                views.lineDashView.frame.origin.y = point.y
                views.lineDashView.frame.size.height = -point.y + views.lineDashView.screenWidth + 60
                break
            }
        }
        let kTOCropViewMinimumBoxSize = 44
        // フォーカスの最小枠と最大枠
        let minSize = CGSize(width: kTOCropViewMinimumBoxSize, height: kTOCropViewMinimumBoxSize)
        let maxSize = CGSize(width: views.lineDashView.frame.maxX, height: views.lineDashView.frame.maxY)
        views.lineDashView.frame.size.width  = max(views.lineDashView.frame.size.width, minSize.width)
        views.lineDashView.frame.size.height  = max(views.lineDashView.frame.size.height, minSize.height)
        
        views.lineDashView.frame.size.width  = min(views.lineDashView.frame.size.width, maxSize.width)
        views.lineDashView.frame.size.height  = min(views.lineDashView.frame.size.height, maxSize.height)
        
        views.lineDashView.frame.origin.x  = max(views.lineDashView.frame.origin.x, views.lineDashView.frame.minX)
        views.lineDashView.frame.origin.x = min(views.lineDashView.frame.origin.x, views.lineDashView.frame.maxX - minSize.width)
        
        views.lineDashView.frame.origin.y  = max(views.lineDashView.frame.origin.y, views.lineDashView.frame.minY)
        views.lineDashView.frame.origin.y  = min(views.lineDashView.frame.origin.y, views.lineDashView.frame.maxY - minSize.height)
        
    }

    //フォーカスの形により座標、サイズの設定のメソッド呼び出し
    func matchGround(views: ViewController,imageView: UIImageView) {
        let sizeSet = views.lineDashView.frame.size
        if (sizeSet.width / sizeSet.height) > 0.5 && 1.5 > (sizeSet.width / sizeSet.height)  {
            if views.lineDashView.frame.width < UIScreen.main.bounds.width/2 || views.lineDashView.frame.height < UIScreen.main.bounds.height/2{
                matchSquareSmall(views: views, imageView: imageView)
            } else {
                matchSquare(views: views, imageView: imageView)
            }
        }else if (sizeSet.width / sizeSet.height) < 0.7 || 1.45 < (sizeSet.width / sizeSet.height)  {
            if views.lineDashView.frame.height > views.lineDashView.frame.width {
                matchVertical(views: views, imageView: imageView)
            } else {
                matchSide(views: views, imageView: imageView)
            }
        } else {
            matchSquareSmall(views: views, imageView: imageView)
        }
        views.cALayerView.tori(vc: views, bool: true)
    }
    
    func matchSquare(views: ViewController,imageView: UIImageView){
        UIView.animate(withDuration: TimeInterval(0),
                       animations: {
        }, completion: { _ in
            UIView.animate(withDuration: 0,
                           animations: {
                            self.originY = ((views.lineDashView.openImageView.frame.height)/views.lineDashView.frame.size.height)
                            self.originX = (views.lineDashView.openImageView.frame.width/views.lineDashView.frame.size.width)
                            views.imageView.frame.size.height = views.imageView.frame.height*self.originY
                            views.lineDashView.frame.size.height = views.lineDashView.frame.size.height * self.originY
                            views.imageView.frame.size.width = (views.imageView.frame.width * self.originX)
                            views.lineDashView.frame.size.width = views.lineDashView.openImageView.frame.size.width
                            
                            let centerY = (views.view.frame.size.height/2) - ((views.lineDashView.frame.size.height)/2)
                            let centerX = (views.view.frame.size.width/2) - ((views.lineDashView.frame.size.width)/2)
                            
                            views.imageView.frame.origin.y = ((-views.lineDashView.frame.origin.y*self.originY) + views.imageView.frame.origin.y*self.originY) + centerY
                            views.imageView.frame.origin.x = ((-views.lineDashView.frame.origin.x*self.originX) + views.imageView.frame.origin.x*self.originX) + centerX
                            views.lineDashView.frame.origin.y = centerY
                            views.lineDashView.frame.origin.x = centerX
            
                            views.cALayerView.hollowTargetLayer.backgroundColor = UIColor.clear.cgColor
                            views.lineDashView.isHidden = true
            })
        })
    }

    func matchSquareSmall(views: ViewController,imageView: UIImageView){
        UIView.animate(withDuration: TimeInterval(0),
                       animations: {
        }, completion: { _ in
            UIView.animate(withDuration: 0,
                           animations: {
                            self.originY = ((views.lineDashView.openImageView.frame.height)/views.lineDashView.frame.size.height)
                            self.originX = (views.lineDashView.openImageView.frame.width/views.lineDashView.frame.size.width)
                            views.imageView.frame.size.height = views.imageView.frame.height * self.originX
                            views.lineDashView.frame.size.height = views.lineDashView.frame.size.height * self.originX
                            views.imageView.frame.size.width = (views.imageView.frame.width * self.originX)
                            views.lineDashView.frame.size.width = views.lineDashView.openImageView.frame.size.width
                            
                            let centerY = (views.view.frame.size.height/2) - ((views.lineDashView.frame.size.height)/2)
                            let centerX = (views.view.frame.size.width/2) - ((views.lineDashView.frame.size.width)/2)
                            
                            views.imageView.frame.origin.y = (-views.lineDashView.frame.origin.y * self.originX) + (views.imageView.frame.origin.y * self.originX) + centerY - 30
                            views.imageView.frame.origin.x = (-views.lineDashView.frame.origin.x * self.originX) + (views.imageView.frame.origin.x * self.originX) + centerX
                            views.lineDashView.frame.origin.y = centerY - 30
                            views.lineDashView.frame.origin.x = centerX
                            
                            views.cALayerView.hollowTargetLayer.backgroundColor = UIColor.clear.cgColor
                            views.lineDashView.isHidden = true
            })
        })
    }

    func matchSide(views: ViewController,imageView: UIImageView){
        UIView.animate(withDuration: TimeInterval(0),
                       animations: {
        }, completion: { _ in
            UIView.animate(withDuration: 0,
                           animations: {
                            self.originY = ((views.lineDashView.openImageView.frame.height)/views.lineDashView.frame.size.height)
                            self.originX = (views.lineDashView.openImageView.frame.width/views.lineDashView.frame.size.width)
                            views.imageView.frame.size.width = (views.imageView.frame.width * self.originX)
                            views.lineDashView.frame.size.width = views.lineDashView.openImageView.frame.size.width
                            views.lineDashView.frame.size.height = views.lineDashView.frame.size.height * self.originX
                            views.imageView.frame.size.height = ((views.imageView.frame.height * self.originX))
                            
                            let centerY = (views.view.frame.size.height/2) - ((views.lineDashView.frame.size.height)/2)
                            let centerX = (views.view.frame.size.width/2) - ((views.lineDashView.frame.size.width)/2)
                            
                            views.imageView.frame.origin.x = ((-views.lineDashView.frame.origin.x*self.originX) + views.imageView.frame.origin.x*self.originX ) + centerX
                            views.imageView.frame.origin.y = ((-views.lineDashView.frame.origin.y*self.originX) + views.imageView.frame.origin.y*self.originX ) + centerY
                            views.lineDashView.frame.origin.y = centerY
                            views.lineDashView.frame.origin.x = centerX
                            
                            views.cALayerView.hollowTargetLayer.backgroundColor = UIColor.clear.cgColor
                            views.lineDashView.isHidden = true
            })
        })
    }

    func matchVertical(views: ViewController,imageView: UIImageView){
        UIView.animate(withDuration: TimeInterval(0),
                       animations: {
        }, completion: { _ in
            UIView.animate(withDuration: 0,
                           animations: {
                            if views.lineDashView.frame.size.width < (views.lineDashView.openImageView.frame.width/5)  {
                                self.magnification = 6.5
                            } else if views.lineDashView.frame.size.width < (views.lineDashView.openImageView.frame.width/4)  {
                                self.magnification = 3.5
                            }else if views.lineDashView.frame.size.width < (views.lineDashView.openImageView.frame.width/3)  {
                                self.magnification = 3
                            } else if views.lineDashView.frame.size.width < (views.lineDashView.openImageView.frame.width/2)  {
                                self.magnification = 2
                            } else if views.imageView.frame.size.width > (views.view.frame.width)  {
                                self.magnification = 2.5
                            } else {
                                self.originY = 1.0
                                self.originX = 1.0
                                self.magnification = 1.0
                            }
                            self.originY = ((views.lineDashView.openImageView.frame.height)/views.lineDashView.frame.size.height)
                            self.originX = (views.lineDashView.openImageView.frame.width/views.lineDashView.frame.size.width)
                            
                            views.imageView.frame.size.width = (views.imageView.frame.width * self.originX/self.magnification)
                            views.imageView.frame.size.height = (views.imageView.frame.height * self.originX/self.self.magnification)
                            
                            views.lineDashView.frame.size.width = views.lineDashView.frame.size.width * (self.originX/self.magnification)
                            views.lineDashView.frame.size.height = views.lineDashView.frame.height * self.originX/self.magnification
                            
                            let centerY = (views.view.frame.size.height/2) - ((views.lineDashView.frame.size.height)/2)
                            let centerX = (views.view.frame.size.width/2) - ((views.lineDashView.frame.size.width)/2)
                            
                            views.imageView.frame.origin.x = ((-views.lineDashView.frame.origin.x*(self.originX/self.magnification)) + views.imageView.frame.origin.x*self.originX/self.magnification) + centerX
                            views.imageView.frame.origin.y = ((-views.lineDashView.frame.origin.y*(self.originX/self.magnification)) + views.imageView.frame.origin.y*self.originX/self.magnification) + centerY
                            views.lineDashView.frame.origin.x = centerX
                            views.lineDashView.frame.origin.y = centerY
                            
                            views.cALayerView.hollowTargetLayer.backgroundColor = UIColor.clear.cgColor
                            views.lineDashView.isHidden = true
            })
        })
    }
}
