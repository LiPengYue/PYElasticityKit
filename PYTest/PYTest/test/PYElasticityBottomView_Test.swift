//
//  PYElasticityBottomView_Test.swift
//  PYTest
//
//  Created by 李鹏跃 on 2017/11/20.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYElasticityBottomView_Test: PYElasticityBottomView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        let label = UILabel()
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        label.text = "我是bottom视图"
        label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }
    

}
