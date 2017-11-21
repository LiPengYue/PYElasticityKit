//
//  UIView+Extension.swift
//  PYTest
//
//  Created by 李鹏跃 on 2017/11/20.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

extension UIView {
    typealias UIVIEWBACKBLOCK = (_ signalKey: String, _ messageObj: Any)->(Any)?
    struct UIVIEWTransmitExtension {
        static let UIVIEWBACKBLOCKKEY = UnsafeRawPointer.init(bitPattern:"EVENTCALLBACKBLOCKKEY".hashValue)
    }
    
  
    
    @discardableResult
    public func viewDispachData (signalKey SignalKey: String, message Message: Any) -> (Any)? {
        var eventBlock: EVENTCALLBACKBLOCK? = objc_getAssociatedObject(self, UIVIEWTransmitExtension.UIVIEWBACKBLOCKKEY!) as? EVENTCALLBACKBLOCK
        if (eventBlock == nil) {
            eventBlock = {(SignalKey, Message) -> (Any)? in
                print("\(self)暂时没有,注册对赢得block，请检查，你想传传递的信息为： \n\n: SignalKey: \(SignalKey)\n\n,Message: \(Message)")
            }
        }
        print("👌\(self):\(SignalKey)")
        return eventBlock!(SignalKey,Message) as (Any)?
    }
    
    
    /// view发送消息 （循环遍历的字数图）
    ///
    /// - Parameters:
    ///   - Dispacher: 发送消息的父视图
    ///   - ReceiverClass: 需要接受消息的子视图 class
    ///   - Data: 发送的数据
    func viewDispachData(receiverClass ReceiverClass: AnyClass, data Data:Any,signalKey SignalKey: String) {
        for view in self.subviews {
            if NSStringFromClass(view.classForCoder) == NSStringFromClass(ReceiverClass) {
                view.viewDispachData(signalKey: SignalKey, message: Data)
            }
        }
    }
    ///** view 接收 viewDispachData 函数发出的消息
    func viewDispachDataReciveFunc(eventCallBack: @escaping EVENTCALLBACKBLOCK) {
        objc_setAssociatedObject(self, UIVIEWTransmitExtension.UIVIEWBACKBLOCKKEY!, eventCallBack, .OBJC_ASSOCIATION_COPY)
    }
}
