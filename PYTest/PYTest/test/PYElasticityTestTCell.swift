//
//  PYElasticityTestTCell.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYElasticityTestTCell: PYElasticityTableViewCell {
    let topView = PYTopViewTest()
    let bottomView = PYElasticityBottomView_Test()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configurationCollectionViwFunc(layout: self.layout, cellClass: PYCollectionViewCell.classForCoder(), maxShowItem: 2, maxRowItemNum: 2, isHiddenButton: false, topView: topView, bottomView: bottomView, topViewH: kViewCurrentH_XP(H: 100), bottomViewH: kViewCurrentH_XP(H: 100))
        self.setUPButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layoutF = UICollectionViewFlowLayout()
        layoutF.itemSize = CGSize(width: kViewCurrentW_XP(W: 325), height: kViewCurrentW_XP(W: 202))
        layoutF.scrollDirection = .vertical
        layoutF.minimumLineSpacing = kViewCurrentW_XP(W: 40)
        layoutF.minimumInteritemSpacing = kViewCurrentW_XP(W: 30)
        layoutF.sectionInset = UIEdgeInsetsMake(kViewCurrentW_XP(W: 30), kViewCurrentW_XP(W: 30), 0, kViewCurrentW_XP(W: 30))
        return layoutF
    }()
    private func setUPButton() {
        //未完成数据展示的collectionView展示
       collectionViewBottomButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.collectionViewBottomButton.setTitle("button", for: .normal)
        self.collectionViewBottomButton.titleLabel?.font = UIFont.kr_font(size: 26)
        self.collectionViewBottomButton.setTitle("更多", for: .normal)
        self.collectionViewBottomButton.setTitle("收起", for: .selected)
        collectionViewBottomButton.setTitleColor(UIColor.gray, for: .normal)
        collectionViewBottomButton.setTitleColor(UIColor.black, for: .selected)
        
        self.viewDispachDataReciveFunc {[weak self] (key, message) -> (Any)? in
            self?.topView.label.text = message as? String
        }
    }
    
    var modelArray: [Any]?{
        didSet {
            self.setCollectionViewData(data: modelArray ?? [])
        }
    }
}
