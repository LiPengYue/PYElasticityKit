//
//  PYTopViewTest.swift
//  PYTest
//
//  Created by 李鹏跃 on 2017/11/17.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYTopViewTest: PYElasticityTopView {
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
        label.text = "我是top视图"
        label.textColor = #colorLiteral(red: 0.7344857193, green: 0.9098039269, blue: 0.7375685475, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
