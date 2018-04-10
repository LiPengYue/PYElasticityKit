//
//  ViewController.swift
//  PYTest
//
//  Created by 李鹏跃 on 2017/11/17.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = bottomLabel
        
        let tableView = PYTableView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight - 30), style: .grouped)
        view.addSubview(tableView)
        
        //注册通道
        NSObject.receive(sender: tableView) { [weak self] (signalKey, message) -> (Any)? in
            
            let vc = PYPushVC()
            if signalKey == K_PYCollectionViewCell_clickImageView {
                self?.present(vc, animated: true, completion: nil)
                vc.receivedSignalFunc(eventCallBack: {(signalKey, message) -> (Any)? in
                    if signalKey == k_PYPushVC_ClickButtonKey {
                        //发送 消息给tableview
                        label.text = (message as! String)
                    }
                    return nil
                })
            }
            return nil 
        }
    }
    
    ///懒加载 bottomLabel
    private lazy var bottomLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: screenHeight - 30, width: screenWidth, height: 30))
        view.addSubview(label)
        label.text = "点击鱼，换文字"
        label.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        
        return label
    }()
}

