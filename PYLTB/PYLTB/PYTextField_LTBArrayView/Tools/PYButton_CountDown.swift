
//
//  KRBaseView_CountDownButtonView.swift
//  KoalaReadingTeacher
//
//  Created by 李鹏跃 on 17/8/17.
//  Copyright © 2017年 Koalareading. All rights reserved.
//

import UIKit

class PYButton_CountDown: UIButton {
    override init(frame: CGRect) {
        normalStr = ""
        self.selectedStr = ""
        super.init(frame: frame)
        self.addObserver(self, forKeyPath: "isSelected", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    ///MARK: - 属性
    var timer: DispatchSourceTimer?
    /// 倒计时总数 （默认60）
    var totalTime: NSInteger = 60
    var currentTime: NSInteger = 60
    
    /// 倒计时频率 （默认1s）
    var countDownFrequency: NSInteger = 1
    
    ///color
    var normalBackgroundColor: UIColor?
    var selectedBackgroundColor: UIColor?
    
    /// 改变selected的时候调用
    var changeSelectedCallBack: ((_ isSelected: Bool)->())?
    
    ///倒计时的回调属性
    var countDownCallBack: ((_ leftTime: NSInteger)->(String)?)?
    
    ///normal 状态下的字符
    var normalStr: String = "" {
        didSet {
            self.setTitle(normalStr, for: .normal)
        }
    }
    ///倒计时状态下的字符
    var selectedStr: String {
        didSet {
            self.setTitle(selectedStr, for: .selected)
        }
    }
    
    ///倒计时的回调 用来拼接字符串用
    ///
    /// - Parameter countDownCallBack: 倒计时剩余时间 回调 返回自己拼接的字符串
    func contDownCallBackFunc(countDownCallBack: @escaping (_ leftTime: NSInteger)->(String)?) {
        self.countDownCallBack = countDownCallBack
    }

    /// 开启定时器
    func timerResume() {
        self.setUPTimer()
    }
    
    /// 停止定时器
    func timerCancel() {
        self.stopTimer()
    }
    deinit {
        self.timerCancel()
        self.removeObserver(self, forKeyPath: "isSelected")
        print("✅ \(self)被销毁")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isSelected" {
            let newValue: Bool = change?[NSKeyValueChangeKey.newKey] as! Bool
            if self.selectedBackgroundColor != nil || newValue{
                self.backgroundColor = self.selectedBackgroundColor!
            }
            if normalBackgroundColor != nil && !newValue {
                self.backgroundColor = self.normalBackgroundColor!
            }
            
            self.changeSelectedCallBack?(newValue)
        }
    }
}



///定时器
private extension PYButton_CountDown {
    
    //MARK: 设置 timer
    func setUPTimer() {
        currentTime = totalTime
        
        self.isUserInteractionEnabled = false
        self.isSelected = true
        
        /**创建timer
         * flags: 一个数组，（暂时不知干吗用的，请大神指教）
         * queue: timer 在那个队列里面执行
         */
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        ///设置timer的计时参数
        /**
         wallDeadline: 什么时候开始
         leeway: 调用频率,即多久调用一次
         */
        //循环执行，马上开始，间隔为1s,误差允许10微秒
        timer?.scheduleRepeating(deadline: DispatchTime.now(), interval: .seconds(countDownFrequency), leeway: .milliseconds(10))
        
        ///执行timer
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
                self.currentTime -= 1
                print("\(self.currentTime)")
                if self.currentTime <= 0 {
                    self.currentTime = self.totalTime
                    self.isUserInteractionEnabled = true
                    self.isSelected = false
                    self.selectedStr = self.normalStr
                    self.timerCancel()
                }
                
                if self.selectedBackgroundColor != nil && self.isSelected {
                    self.backgroundColor = self.selectedBackgroundColor!
                }
                if self.normalBackgroundColor != nil && !self.isSelected {
                    self.backgroundColor = self.normalBackgroundColor!
                }
                
                self.changeSelectedCallBack?(self.isSelected)
                self.selectedStr = self.countDownCallBack?(self.currentTime) ?? "\(self.currentTime)"
            }
        })
        ///执行timer
        self.timer?.resume()
    }
    
    //MARK: 停止定时器
    func stopTimer() {
        self.timer?.cancel()
        self.timer = nil
    }
}
