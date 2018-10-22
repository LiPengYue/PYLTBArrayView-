//
//  PYTextField_LTBArrayVC.swift
//  PYLTB
//
//  Created by 李鹏跃 on 2017/8/19.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYTextField_LTBArrayVC: UIViewController {
    private var textField_LTBArrayView :PYTextField_LTBArrayView?
    private var textField_LTBView: PYTextField_LTBView?
    private var button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.creatView()
        self.setUPFrame()
    }
    private func creatView() {
        ///配置PYTextField_LTBArrayView
         textField_LTBArrayView = PYTextField_LTBArrayView(frame: CGRect.zero, totalCountByTextField: 2, itemViewHeight: UIScreen.kViewCurrentH(H: 90), itmeMargin: UIScreen.kViewCurrentH(H: 20), rightButtonWidth: [UIScreen.kViewCurrentW(W: 200),0], leftLableWidth: [UIScreen.kViewCurrentW(W: 150)], leftStrArray: [
            "手机号:",
            "验证码:"
            ], rightButtonStr: [
            "发送验证码",
            ""
            ], midTextFieldPlaceholderArray: [
            "请输入手机号",
            "请输入验证码"
            ])
        
        
        ///设置
        for textField_LTBView in (textField_LTBArrayView?.textField_LTBViewArray)! {
           textField_LTBView.midTextField.backgroundColor = UIColor.init(white: 0.96, alpha: 1)
            if textField_LTBView.leftLable.text == "手机号:" {
                self.textField_LTBView = textField_LTBView
                self.setUPtextField_LTBView()
            }
        }
        
        ///dissmiss
        button.addTarget(self, action: #selector(clickButton), for:.touchUpInside)
        button.backgroundColor =  UIColor.init(colorLiteralRed: 0.6, green: 0.5, blue: 0.9, alpha: 1)
        button.setTitle("点我dismiss", for: .normal)
        
        self.view.addSubview(textField_LTBArrayView!)
        self.view.addSubview(button)
    }
    @objc private func clickSendCode() {
        textField_LTBView?.rightButton.timerResume()
    }

    private func setUPtextField_LTBView () {
        //发送验证码的 textField_LTBView 的设置
        ///颜色设置
        self.textField_LTBView?.rightButton.backgroundColor = UIColor.init(colorLiteralRed: 0.6, green: 0.5, blue: 0.9, alpha: 1)
        
        self.textField_LTBView?.rightButton.selectedBackgroundColor = UIColor.init(colorLiteralRed: 0.8, green: 0.8, blue: 0.9, alpha: 1)
        
        self.textField_LTBView?.rightButton.normalBackgroundColor = UIColor.init(colorLiteralRed: 0.6, green: 0.5, blue: 0.9, alpha: 1)
        self.textField_LTBView?.rightButton.addTarget(self, action: #selector(clickSendCode), for: .touchUpInside)
        
        //总倒计时时间
        self.textField_LTBView?.rightButton.totalTime = 10
        
        //button.text 设置 回调
        self.textField_LTBView?.rightButton.contDownCallBackFunc(countDownCallBack: { (time) in
            return "\(time)" + "s"
        })
    }
    private func setUPFrame() {
        textField_LTBArrayView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(UIScreen.kViewCurrentH(H: 300))
            make.right.left.equalTo(self.view)
            make.height.equalTo(UIScreen.kViewCurrentH(H: 300))
        })
        button.snp.makeConstraints { (make) in
            make.top.equalTo((textField_LTBArrayView?.snp.bottom)!).offset(UIScreen.kViewCurrentH(H: 30))
            make.left.equalTo(self.view).offset(UIScreen.kViewCurrentW(W: 40))
            make.right.equalTo(self.view).offset(UIScreen.kViewCurrentW(W: -40))
            make.height.equalTo(UIScreen.kViewCurrentH(H: 80))
        }
    }
    
    @objc private func clickButton() {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
