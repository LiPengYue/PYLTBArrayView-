# PYLTBArrayView-
label - textField - Button 结构 的组件封装


![当dismiss时候定时器被销毁了](http://upload-images.jianshu.io/upload_images/4185621-454161d42f95b197.gif?imageMogr2/auto-orient/strip)

# 前言：
> 了解swift GCD 与OC GCD请看我的其他总结文章，这篇文章只是对swift GCD定时器的一个实例探讨，如果有什么不对，请各位指正。

[swift CGD 地址](http://www.jianshu.com/p/fc04be41c698)

[OC CGD 地址](http://www.jianshu.com/p/fc04be41c698)

--- 
**一、 swift  DispatchSourceTimer**
1. 创建方法
*`timer要全局定义，局部定义初始化生命周期太短，不会执行回调`
```
//1. 指定线程 行的)
 /**创建
  * flags: 一个数组，（暂时不知干吗用的，请大神指教）
  * queue: timer 在那个队列里面执
  */
let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())

//2. 默认主线程
let timer = DispatchSource.makeTimerSource()
```
2. 设置回调参数`分为单次执行与循环执行`
````
 /**
wallDeadline: 什么时候开始
leeway: 调用频率,即多久调用一次
*/
//循环执行，马上开始，间隔为1s,误差允许10微秒
timer?.scheduleRepeating(deadline: DispatchTime.now(), interval: .seconds(countDownFrequency), leeway: .milliseconds(10))
//单次执行
timer?.scheduleOneshot(wallDeadline: .now(), leeway: .microseconds(10))
````
3. 回调方法`如果在子线程，别忘了回到主线程`
```
 ///执行timer
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
            }
        })
```
4. 开始执行
```
timer?.resume()
```







---
**二、 定时器 demo对比**
1. oc:` c语言的函数`
```
//0.创建队列
dispatch_queue_t queue = self.queue;
[self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj setValue:@"0" forKey:self.modelCountDownKey];
}];
//1.创建GCD中的定时器
/*
 第一个参数:创建source的类型 DISPATCH_SOURCE_TYPE_TIMER:定时器
 第二个参数:0
 第三个参数:0
 第四个参数:队列
 */
dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
self.timer = timer;
//2.设置定时器
/*
 第一个参数:定时器对象
 第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
 第三个参数:间隔时间 GCD里面的时间最小单位为 纳秒
 第四个参数:精准度(表示允许的误差,0表示绝对精准)
 */
dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, self.countDownUnit * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

//3.要调用的任务
dispatch_source_set_event_handler(timer, ^{
    dispatch_async(self.queue, ^{
        [self lookingForATimelyModelArray:self.modelArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.countdownDataFredbackWithBlock) {
                self.countdownDataFredbackWithBlock();
            }
        });
    });
});

//4.开始执行
dispatch_resume(timer);
```




2. swift: `中的GCD则是一个对象`
```
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
      // 回调 回到了主线程
   }
        })
        ///执行timer
        self.timer?.resume()
```





---
**三、小组件封装**
**1. 组件构成：**
> 组件分为三部分：
>`1.PYButton_CountDown: 带有定时器的button的封装（可以是类扩展，这里采用继承）`
`2. PYTextField_LTBView:对带有左边label，中间textField，右边PYButton_CountDown的的封装`
`3. PYTextField_LTBArrayView: 根据外部传递的信息创建多层上下结构的PYTextField_LTBView`


**2. 单元组件**

 Button的封装（PYButton_CountDown）
>大体思路：
`这里可以用分类，本次封装用的是继承方法封装。`
 1.创建一个定时器，告诉定时器的倒计时总数`var totalTime: NSInteger = 60`
2.提供开启和取消定时器的方法`func timerResume()` `func timerCancel()`
3.当定时器启动的时候，按钮是不能点击的，当倒计时完成在次可以点击
4.倒计时Button的UI显示的字符串的扩展，要通过一个闭包回调当前时间，并且要求闭包返回一个字符串，进行UI展示
`func contDownCallBackFunc(countDownCallBack: @escaping (_ leftTime: NSInteger)->(String)?)`

1. 属性 (public)
```
    ///计时器
    var timer: DispatchSourceTimer?
    /// 倒计时总数 （默认60）
    var totalTime: NSInteger = 60
    var currentTime: NSInteger = 60
    
    /// 倒计时频率 （默认1s）
    var countDownFrequency: NSInteger = 1
    
    ///normal状态的background color
    var normalBackgroundColor: UIColor?
    ///倒计时时候的background color
    var selectedBackgroundColor: UIColor?
 
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
    /// 改变selected的时候调用
    var changeSelectedCallBack: ((_ isSelected: Bool)->())?
 
    ///倒计时的回调属性
    var countDownCallBack: ((_ leftTime: NSInteger)->(String)?)?
```

2. 方法
```
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
```
[简书总结分析点这里~](http://www.jianshu.com/p/fc04be41c698)
