//
//  NSObectEventTransmit+Extension.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/11/3.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit

extension NSObject {
    
    typealias EVENTCALLBACKBLOCK = (_ signalKey: String, _ messageObj: Any)->(Any)?
    typealias receivedBlock<T: NSObjectProtocol> = (_ signalKey: String, _ messageObj: T)->(Any)?
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
                print("\(self.classForCoder)暂时没有,注册block，\n请检查，你想传传递的信息为： \n\n  👌SignalKey: \(SignalKey)\n\n  👌Message: \(Message)")
            }
        }
        print("\n     👌链接成功 \(self.classForCoder)\n     👌 Key为: \(SignalKey)")
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
    class func stitchChannelFunc(sender Sender: NSObject?, relay Relay: NSObject?) {
        if Sender == nil || Relay == nil{
            print("🌶：：sender或者receiver为nil")
            return
        }
        Sender!.receivedSignalFunc {[weak Relay] (signalKey, message) -> (Any)? in
            return Relay?.sendSignalFunc(signalKey: signalKey, message: message)
        }
    }
    
    /// 接收信息
    ///
    /// - Parameters:
    ///   - sendDer: 发起信息者
    ///   - receiver: 接收信息者
    ///   - message: 具体信息
    class func receive(sender Sender: NSObject?, message: EVENTCALLBACKBLOCK?) {
        if Sender == nil{
            print("🌶：：sender为nil")
            return
        }
        if message == nil {
            print("🌶：：message为nil")
            return
        }
        Sender?.receivedSignalFunc(eventCallBack: message!)
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
    
    class func receive<T: NSObjectProtocol>(sender Sender: NSObject?, message: receivedBlock<T>?) {
        if Sender == nil{
            print("🌶：：sender为nil")
            return
        }
        if message == nil {
            print("🌶：：message为nil")
            return
        }
        Sender?.receivedSignalFunc(eventCallBack: message!)
        
    }
    
    ///即： 这里可以拿到下级对象发出的消息
    func receivedSignalFunc<T: NSObjectProtocol>(eventCallBack: @escaping receivedBlock<T>) {
        objc_setAssociatedObject(self, NSObectEventTransmitExtension.EVENTCALLBACKBLOCKKEY!, eventCallBack, .OBJC_ASSOCIATION_COPY)
    }
}


