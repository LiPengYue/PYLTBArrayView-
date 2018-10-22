//
//  PYScreen+Extension.swift
//  PYLTB
//
//  Created by 李鹏跃 on 2017/8/19.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit
//屏幕尺寸
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenBounds = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

//屏幕适配（长宽）
let designW: CGFloat = 375
let designH: CGFloat = 667
let designScale: CGFloat = 2;



let currentWidth = screenWidth/designW
let currentHeight = screenHeight/designH

func ptW(w: CGFloat) -> CGFloat {
    return UIScreen.kViewCurrentW(W: w)
}
func ptH(h: CGFloat) -> CGFloat {
    return UIScreen.kViewCurrentH(H: h)
}
func pxW(w: CGFloat) -> CGFloat {
    return UIScreen.kViewCurrentWidth(W:w)
}
func pxH(h: CGFloat) -> CGFloat {
    return UIScreen.kViewCurrentHeight(H: h);
}
extension UIScreen {
   
    ///view的宽度比例计算
    class func kViewCurrentWidth (W: CGFloat) -> (CGFloat) {
        return W * currentWidth
    }
    ///view的高度比例计算
    class func kViewCurrentHeight (H: CGFloat) -> (CGFloat) {
        return H * currentHeight
    }
    ///H/2
    class func kViewCurrentH (H: CGFloat) -> (CGFloat) {
        return H * currentHeight / designScale
    }
    /// W/2
    class func kViewCurrentW (W: CGFloat) -> (CGFloat) {
        return W * currentWidth / designScale
    }
    
}
