

//
//  PYCollectionViewCell.swift
//  PYTest
//
//  Created by 李鹏跃 on 2017/11/17.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let label = UILabel()
    let imageView = UIImageView()
    private func setUP () {
        addSubview(imageView)
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.left.equalTo(self)
        }
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = NSTextAlignment.center
        imageView.image = UIImage.init(named: "2")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}
