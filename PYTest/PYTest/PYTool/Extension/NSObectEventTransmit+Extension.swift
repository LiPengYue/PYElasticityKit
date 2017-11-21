//
//  NSObectEventTransmit+Extension.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/15.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit


extension NSObject {
    
    typealias EVENTCALLBACKBLOCK = (_ signalKey: String, _ messageObj: Any)->(Any)?
    struct NSObectEventTransmitExtension {
        static let EVENTCALLBACKBLOCKKEY = UnsafeRawPointer.init(bitPattern:"EVENTCALLBACKBLOCKKEY".hashValue)
        static let MODELKEY = UnsafeRawPointer.init(bitPattern:"MODELKEY".hashValue)
        static let DIC = UnsafeRawPointer.init(bitPattern:"MODELKEY".hashValue)
    }
    
    ///** 上级 的对象对下级对象事件处理注册，
    ///即： 这里可以拿到下级对象发出的消息
    func receivedSignalFunc(eventCallBack: @escaping EVENTCALLBACKBLOCK) {
        objc_setAssociatedObject(self, NSObectEventTransmitExtension.EVENTCALLBACKBLOCKKEY!, eventCallBack, .OBJC_ASSOCIATION_COPY)
    }
    
    @discardableResult
    public func sendSignalFunc (signalKey SignalKey: String, message Message: Any) -> (Any)? {
        var eventBlock: EVENTCALLBACKBLOCK? = objc_getAssociatedObject(self, NSObectEventTransmitExtension.EVENTCALLBACKBLOCKKEY!) as? EVENTCALLBACKBLOCK
        if (eventBlock == nil) {
            eventBlock = {(SignalKey, Message) -> (Any)? in
                print("\(self)暂时没有,注册对赢得block，请检查，你想传传递的信息为： \n\n: SignalKey: \(SignalKey)\n\n,Message: \(Message)")
            }
        }
        print("👌\(self):\(SignalKey)")
        return eventBlock!(SignalKey,Message) as (Any)?
    }
    
    ///快速通道
    func stitchChannelFunc(sender Sender: NSObject?) {
        if Sender == nil {
            print("🌶：：sender为你nil\(self)")
            return
        }
        Sender!.receivedSignalFunc { (signalKey, message) -> (Any)? in
            return self.sendSignalFunc(signalKey: signalKey, message: message)
        }
    }

    ///储存数据的model
    var modelObj: Any {
        get {
            return objc_getAssociatedObject(self, NSObectEventTransmitExtension.MODELKEY!)
        }set {
            objc_setAssociatedObject(self, NSObectEventTransmitExtension.MODELKEY!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    ///逆传
    class func stitchChannelFunc(sender Sender: NSObject?, receiver Receiver: NSObject?) {
        if Sender == nil || Receiver == nil{
            print("🌶：：sender或者receiver为nil")
            return
        }
        Sender!.receivedSignalFunc {[weak Receiver] (signalKey, message) -> (Any)? in
            return Receiver?.sendSignalFunc(signalKey: signalKey, message: message)
        }
    }
    
    
    ///顺传
    ///储存数据的 dic
    var reserveDicObj: [String:Any] {
        get {
            return objc_getAssociatedObject(self, NSObectEventTransmitExtension.DIC!) as! [String : Any]
        }set {
            objc_setAssociatedObject(self, NSObectEventTransmitExtension.DIC!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

