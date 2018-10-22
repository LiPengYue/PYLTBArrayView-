//
//  KRBaseViewTextField_SendView.swift
//  KoalaReadingTeacher
//
//  Created by 李鹏跃 on 17/8/17.
//  Copyright © 2017年 Koalareading. All rights reserved.
//

import UIKit

class PYTextField_LTBView: UIView {

    let leftLable = UILabel(frame: CGRect.zero)
    let midTextField = UITextField(frame: CGRect.zero)
    let rightButton = PYButton_CountDown(frame: CGRect.zero)
    
    let margin: UIEdgeInsets = UIEdgeInsets.init()
    ///左边的lable距离self。left的距离
    var marginLeft: CGFloat = 0.0
    ///self.rightButton.right 与 self.right 的间距
    var marginRight: CGFloat = 0.0
    ///self.leftLable.right距离midTextField.left的距离
    var marginLableRight: CGFloat = 0.0
    ///self.rightButton.left距离midTextField.right的距离
    var marginButtonLeft: CGFloat = 0.0
    /// 右边的宽度
    var rightButtonWidth: CGFloat = 0.0
    /// 左边的宽度
    var leftLableWidth: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUP()
    }
    
    private func setUP() {
        self.addSubview(leftLable)
        self.addSubview(midTextField)
        self.addSubview(rightButton)
    }
    
    override func didMoveToSuperview() {
        self.setUPSubViewFrame()
    }
    
    private func setUPSubViewFrame() {
        leftLable.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self).offset(marginLeft)
            make.width.equalTo(leftLableWidth)
        }
        rightButton.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(leftLable)
            make.right.equalTo(self).offset(-marginRight)
            make.width.equalTo(rightButtonWidth)
        }
        midTextField.snp.makeConstraints { (make) in
            make.left.equalTo(leftLable.snp.right).offset(marginLableRight)
            make.right.equalTo(rightButton.snp.left).offset(-marginButtonLeft)
            make.bottom.top.equalTo(rightButton)
        }
    }
    
    deinit {
        self.rightButton.timerCancel()
        print("✅ \(self)被销毁")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
