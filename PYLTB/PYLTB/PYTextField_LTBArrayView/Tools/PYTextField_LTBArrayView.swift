//
//  KRBaseViewTextFieldArrayView.swift
//  KoalaReadingTeacher
//
//  Created by 李鹏跃 on 17/8/17.
//  Copyright © 2017年 Koalareading. All rights reserved.
//

import UIKit

class PYTextField_LTBArrayView: UIView {
    
    ///包含的textField的数组 只读
    var textField_LTBViewArray: [PYTextField_LTBView]
    {
        get {
            return textField_SendViewArrayPrivate
        }
    }
    
    
    /// 个性设置
    func setUPTextFieldSendViewFunc(setUPTextFieldSendViewCallBack: @escaping (_ textFieldSendView: PYTextField_LTBView,_ index:NSInteger)->()) {
        self.setUPTextFieldSendViewCallBack = setUPTextFieldSendViewCallBack
    }
    
    var margin: UIEdgeInsets = UIEdgeInsets.init()
    ///左边的lable距离self。left的距离
    var marginLeft: CGFloat = UIScreen.kViewCurrentW(W: 20)
    ///self.rightButton.right 与 self.right 的间距
    var marginRight: CGFloat = UIScreen.kViewCurrentW(W: 20)
    ///self.leftLable.right距离midTextField.left的距离
    var marginLableRight: CGFloat =  UIScreen.kViewCurrentW(W: 10)
    ///self.rightButton.left距离midTextField.right的距离
    var marginButtonLeft: CGFloat = 0.0
    
    /// 右边的宽度
    private var rightWidthArray: [CGFloat]?
    /// 左边的宽度
    private var leftWidthArray: [CGFloat]?
    
    
    
    /// 上下几个 lable — textField - button 格式 （可扩展，不过数组的count一定要与totalCountByTextField一样)
    ///
    /// - Parameters:
    ///   - frame: 大小（可以不传）
    ///   - totalCountByTextField:  一共有多少层
    ///   - itemViewHeight: 单个itme的高度
    ///   - itmeMargin: 两个item之间的间距
    ///   - leftLableWidth: 左边的宽度 是数组
    ///   - rightButtonWidth: 右边的宽度 是数组
    ///   - leftStrArray: lable的字符串数组
    ///   - rightButtonStr: button的字符串数组
    ///   - midTextFieldPlaceholderArray: 中间的Placeholder string
    
    init(frame: CGRect,totalCountByTextField: NSInteger,itemViewHeight: CGFloat,itmeMargin: CGFloat,rightButtonWidth: [CGFloat],leftLableWidth: [CGFloat], leftStrArray: [String]?,rightButtonStr: [String]?,midTextFieldPlaceholderArray: [String]?) {
        
        super.init(frame: frame)
        self.itmeMargin = itmeMargin
        self.itemViewHeight = itemViewHeight
        self.totalCountByTextField = totalCountByTextField
        self.leftStrArray = leftStrArray
        self.rightButtonStr = rightButtonStr
        self.midTextFieldPlaceholderArray = midTextFieldPlaceholderArray
        
        self.rightWidthArray = rightButtonWidth
        self.leftWidthArray = leftLableWidth
        
        self.setUP()
    }
    
    func setUP() {
        for view in subviews {
            view.removeFromSuperview()
        }
        self.textField_SendViewArrayPrivate.removeAll()
        
        for i in 0..<totalCountByTextField {
            if ((self.leftStrArray?.count) ?? 0 < i) {
                print("🌶 左边lable 的数组越界了")
            }
            
            let view: PYTextField_LTBView = PYTextField_LTBView(frame: CGRect.zero)
            
            if (self.rightButtonStr?.count ?? -1) > i {
                view.rightButton.setTitle(self.rightButtonStr?[i], for: .normal)
            }
            if self.midTextFieldPlaceholderArray?.count ?? -1 > i {
                view.midTextField.placeholder = self.midTextFieldPlaceholderArray?[i]
            }
            if (self.leftStrArray?.count ?? 0 > i) {
                view.leftLable.text = self.leftStrArray?[i]
            }
            self.textField_SendViewArrayPrivate.append(view)
        }
    }
    func setUPValue() {
        for i in 0..<self.textField_LTBViewArray.count {
            let view = self.textField_LTBViewArray[i]
            view.marginLeft = marginLeft
            ///self.rightButton.right 与 self.right 的间距
            view.marginRight = marginRight
            ///self.leftLable.right距离midTextField.left的距离
            view.marginLableRight = marginLableRight
            ///self.rightButton.left距离midTextField.right的距离
            view.marginButtonLeft = marginButtonLeft
            
            if leftWidthArray?.count ?? -1 > i {
                let leftIdx = (leftWidthArray?.count) ?? 0 <= 1 ? 0 : i
                
                view.leftLableWidth =  (self.leftWidthArray?[leftIdx])!
            }
            if rightWidthArray?.count ?? -1 > i {
                let rightIdx = (rightWidthArray?.count) ?? 0 <= 1 ? 0 : i
                view.rightButtonWidth = (self.rightWidthArray?[rightIdx])!
            }
            
            
            ///外建设置
            self.setUPTextFieldSendViewCallBack?(view,i)
            self.addSubview(view)
        }
    }
    override func didMoveToSuperview() {
        self.setUPValue()
        self.setUPFrame()
    }
    
    func setUPFrame() {
        for index in 0 ..< self.textField_SendViewArrayPrivate.count {
            let view = self.textField_SendViewArrayPrivate[index]
            if index == 0 {
                view.snp.makeConstraints({ (make) in
                    make.top.equalTo(self).offset(margin.top)
                    make.left.equalTo(self).offset(margin.left)
                    make.right.equalTo(self).offset(-margin.right)
                    make.height.equalTo(itemViewHeight)
                })
                continue
            }
            let viewFront = self.textField_SendViewArrayPrivate[index - 1]
            view.snp.makeConstraints({ (make) in
                make.left.right.height.equalTo(viewFront)
                make.top.equalTo(viewFront.snp.bottom).offset(itmeMargin)
            })
        }
    }
    
    
    private var totalCountByTextField: NSInteger = 0
    private var leftStrArray: [String]?
    private var rightButtonStr: [String]?
    private var midTextFieldPlaceholderArray: [String]?
    private var itemViewHeight: CGFloat = 0.0
    private var itmeMargin: CGFloat = 0.0
    private var textField_SendViewArrayPrivate: [PYTextField_LTBView] = []
    private var setUPTextFieldSendViewCallBack: ((_ textFieldSendView: PYTextField_LTBView, _ index: NSInteger)->())?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        for view in self.textField_LTBViewArray {
            view.rightButton.timerCancel()
        }
        print("✅ \(self)被销毁")
    }
}
