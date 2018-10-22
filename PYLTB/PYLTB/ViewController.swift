//
//  ViewController.swift
//  PYLTB
//
//  Created by 李鹏跃 on 2017/8/19.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.89, alpha: 1)
        self.creatButton()
    }
    private func creatButton () {
        let button = PYButton_CountDown()
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
        button.setTitle("点我present 登陆界面", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 0.6, green: 0.5, blue: 0.9, alpha: 1)
        button.addTarget(self, action: #selector(clickCountDownButton), for: .touchUpInside)
    }
    
    @objc private func clickCountDownButton() {
        self.present(PYTextField_LTBArrayVC(), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

