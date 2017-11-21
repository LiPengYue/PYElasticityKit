//
//  PYPushVC.swift
//  PYTest
//
//  Created by 李鹏跃 on 2017/11/20.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYPushVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUP()
    }

    private func setUP() {
        view.addSubview(textField)
        view.backgroundColor = UIColor.white
        textField.frame = CGRect(x: 10, y: 110, width: screenWidth - 20, height: 30)
        textField.placeholder = "改变viewController底部视图的title"
        
        
        view.addSubview(button)
        button.center = view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.setTitle("确定", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    private let button = UIButton()
    private let textField = UITextField()
    
    @objc private func clickButton() {
        self.sendSignalFunc(signalKey: k_PYPushVC_ClickButtonKey, message: textField.text ?? "传递失败")
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("✅")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
