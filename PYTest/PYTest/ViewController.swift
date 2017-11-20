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
        let tableView = PYTableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

