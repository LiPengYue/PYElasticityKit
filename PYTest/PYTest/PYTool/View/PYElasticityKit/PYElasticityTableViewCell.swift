//
//  KROverdueDecorateTBVCell.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/11/9.
//  Copyright © 2017年 koalareading. All rights reserved.
//
/// ------------------- ~ read me ~ -----------------------
/* 使用：
 1. 继承自PYElasticityTableViewCell，然后自定义一个传输数据的model接口，
 2. 然后在model的didSet方法里面，你要调用*setUPElasticityCollectionViewDataSourceFunc*这个方法，给collectionView传递数据，
 3. 如果不想点击collectionView下面的按钮后自动让你的tableview刷新，那么可以设置属性isAutoReloadData为False，但是你必须要在tableVIew的数据源中，监听到点击事件，并手动刷新，直接复制粘贴下面代码到数据源中，注意message，是collectionView当前的数据源数组。
 ····代码：
 self?.eceivedSignalFunc(eventCallBack: { [weak self](signalKey, message) -> (Any)? in
 if signalKey == PYElasticityTableViewCell_ClickMoreButton {
 /// 你要的点击事件在这里拿到
 self?.reloadData()
 }
 return nil
 })
 ····
 */

import UIKit
let PYElasticityTableViewCell_ClickMoreButton = "PYElasticityTableViewCell_ClickMoreButton"
///self中的collectionView，与self背景色相同
class PYElasticityTableViewCell: UITableViewCell {
    //MARK: - 配置属性
    ///点击后展开按钮后，父控件是否自动刷新数据(默认是true，如果设置成False，请在tableview中的数据源中用receivedSignalFunc函数监听点击事件，然后自行刷新,注意signalKey为PYElasticityTableViewCell_ClickMoreButton)
    var isAutoReloadData: Bool = true
    
    /// update topViewH，如果在创建self的时候，没有给topViewH，那么请不要用这个来更改topView的高度
    var topViewH: CGFloat? = 0 {
        didSet {
            topView.snp.updateConstraints({ (make) in
                make.height.equalTo(topViewH ?? 0)
            })
        }
    }
    /// upDate topViewH， 如果在创建self的时候，没有给bottomViewH，那么请不要用这个来更改bottomView的高度
    var bottomViewH: CGFloat? = 0 {
        didSet {
            bottomView.snp.updateConstraints({ (make) in
                make.height.equalTo(bottomViewH ?? 0)
            })
        }
    }
    /// collectionView的Button
    var collectionViewBottomButton: UIButton {
        get {
            return elasticityCollectionView.button
        }
    }
    
    //MARK: - 配置 collectionView
    /// 配置cell，使得里面有点击按钮可以伸缩的collectionView，《🌶topView与bottomView，自适应🌶》
    ///
    /// - Parameters:
    ///   - layout: collectionViewCell 的layout
    ///   - cellClass: collectionViewCell 的class
    ///   - maxShowItem: 未展开的时候最多展示多少条
    ///   - maxRowItemNum: 每一行有最多有多少
    ///   - isHiddenButton: 是否隐藏底部的Button按钮，隐藏那就默认像是最多数据
    ///   - topView: topview，请在topView中用约束撑起topView
    ///   - bottomView: 同topView

    func configurationCollectionViwFunc(layout: UICollectionViewFlowLayout,cellClass: AnyClass,maxShowItem: NSInteger, maxRowItemNum: NSInteger,isHiddenButton: Bool? = false,buttonInstert: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, 0, 0),topView: PYElasticityTopView? = nil, bottomView: PYElasticityBottomView? = nil) {
        elasticityCollectionViewLayout = layout
        elasticityCollectionViewCellClass = cellClass
        elasticityCollectionView.maxShowItem = maxShowItem
        elasticityCollectionView.maxRowItemNum = maxRowItemNum
        elasticityCollectionView.isHiddenButton = isHiddenButton ?? false
        elasticityCollectionView.buttonInsets = buttonInstert ?? UIEdgeInsetsMake(0, 0, 0, 0)
        self.bottomView = bottomView ?? PYElasticityBottomView()
        self.topView = topView ?? PYElasticityTopView()
        setUPAutoViewFunc()
        registerEvent()
    }
    
    
    /// 配置cell，使得里面有点击按钮可以伸缩的collectionView，《🌶topView与bottomView需要固定高度，不能自适应🌶》
    ///
    /// - Parameters:
    ///   - layout: collectionViewCell 的layout
    ///   - cellClass: collectionViewCell 的class
    ///   - maxShowItem: 未展开的时候最多展示多少条
    ///   - maxRowItemNum: 每一行有最多有多少
    ///   - isHiddenButton: 是否隐藏底部的Button按钮，隐藏那就默认像是最多数据
    ///   - topView: topview，如果设置了topview，那么最好设置topViewH，如果没有设置，请在topView中用约束撑起topView
    ///   - bottomView: 同topView
    ///   - topViewH: topView的高度
    ///   - bottomViewH: 同topViewH
    func configurationCollectionViwFunc(layout: UICollectionViewFlowLayout,cellClass: AnyClass,maxShowItem: NSInteger, maxRowItemNum: NSInteger,isHiddenButton: Bool? = false,buttonInstert: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, 0, 0),topView: PYElasticityTopView? = nil, bottomView: PYElasticityBottomView? = nil,topViewH: CGFloat? = 0, bottomViewH: CGFloat? = 0) {
        elasticityCollectionViewLayout = layout
        elasticityCollectionViewCellClass = cellClass
        elasticityCollectionView.maxShowItem = maxShowItem
        elasticityCollectionView.maxRowItemNum = maxRowItemNum
        elasticityCollectionView.isHiddenButton = isHiddenButton ?? false
        elasticityCollectionView.buttonInsets = buttonInstert ?? UIEdgeInsetsMake(0, 0, 0, 0)
        self.bottomView = bottomView ?? PYElasticityBottomView()
        self.topView = topView ?? PYElasticityTopView()
        self.topViewH = topViewH
        self.bottomViewH = bottomViewH
        setUP()
        registerEvent()
    }
    
   
    
    
    //MARK: - 私有属性
    ///顶部的view
    private var topView: PYElasticityTopView = PYElasticityTopView()
    ///底部的视图
    private var bottomView: PYElasticityBottomView = PYElasticityBottomView()
     private weak var superTableView: UITableView?
    ///设置collectionView的flowLayout
    private var elasticityCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var elasticityCollectionViewCellClass: AnyClass = UICollectionViewCell.classForCoder()
    //MARK: 数据源
    func setCollectionViewData(data Data: [Any]) {
        elasticityCollectionView.isSelected = self.getIsSelected(index: indexPath)
        elasticityCollectionView.modelArray = Data
        let changeNameH =  elasticityCollectionView.currentViewH
        self.elasticityCollectionView.snp.updateConstraints { (make) in
            make.height.equalTo(changeNameH)
        }
    }
    ///必须设置这个值，在你的tableview数据源中
    var indexPath: IndexPath?
   
    private func setUPAutoViewFunc() {
        contentView.addSubview(elasticityCollectionView)
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        let elasticityCollectionViewH = elasticityCollectionView.currentViewH
        
        topView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(contentView)
        })
        elasticityCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(kViewCurrentW_XP(W: 0))
            make.right.equalTo(contentView).offset(kViewCurrentW_XP(W: 0))
            make.bottom.equalTo(contentView)
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(elasticityCollectionViewH)
        }
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(elasticityCollectionView.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
        })
    }
    private func setUP() {
        
        contentView.addSubview(elasticityCollectionView)
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        let elasticityCollectionViewH = elasticityCollectionView.currentViewH
        
        topView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(topViewH ?? 0)
        })
        elasticityCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(kViewCurrentW_XP(W: 0))
            make.right.equalTo(contentView).offset(kViewCurrentW_XP(W: 0))
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(elasticityCollectionViewH)
        }
        bottomView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(elasticityCollectionView.snp.bottom)
            make.height.equalTo(bottomViewH ?? 0)
        })
    }
    
    ///MAKR: 点击事件的注册
    var clickBottomButtonCallBack: ((_ currentH: CGFloat,  _ cell: UITableViewCell)->(IndexPath)?)?
    func clickBottomButtonFunc (_ clickBottomButtonCallBack: ((_ currentH: CGFloat,  _ cell: UITableViewCell)->(IndexPath)?)?) {
        self.clickBottomButtonCallBack = clickBottomButtonCallBack
    }
    private func registerEvent() {
        /// 事件的传递
        stitchChannelFunc(sender: elasticityCollectionView)
        elasticityCollectionView.clickBottomButtonFunc { [weak self] (currentH) -> (IndexPath)? in
            
            //自动刷新
            if self?.indexPath == nil {
                print("🌶\(String(describing: self)).indexpath没有值 导致self?.superTableView?.setIsSelected(index: index)设置失败，你将永远都展不开你的collectionView，🌶🌶请在你的tableview的数据源方法里面，给self的indexPath赋值🌶🌶")
                return nil
            }
            ///更新布局
            self?.superTableView?.setIsSelected(index: (self?.indexPath)!)
            self?.sendSignalFunc(signalKey: PYElasticityTableViewCell_ClickMoreButton, message: self?.collectionViewModelArray ?? [])
            if (self?.isAutoReloadData ?? true) {
                self?.superTableView?.reloadData()
            }
            return nil
        }
    }
    private var collectionViewModelArray: [Any] = []
    private lazy var elasticityCollectionView: PYElasticityCollectionView = {
        let elasticityCollectionView = PYElasticityCollectionView(frame: CGRect.zero, cellClass: elasticityCollectionViewCellClass, layout: elasticityCollectionViewLayout)
        return elasticityCollectionView
    }()
    
    ///==============
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
         superTableView = getScrollView(self)
    }
    private func getScrollView(_ view: UIView) -> (UITableView) {
        if superTableView != nil{
            return self.superTableView!
        }
        if view is UITableView {
            superTableView = view as? UITableView
            return view as! (UITableView)
        }
        if view.superview == nil {
            print("🌶 \\getScrollView(_ view: UIView) -> (UIScrollView)\\ superView为nil")
            return UITableView()
        }
        let scrollView = self.getScrollView(view.superview!)
        return scrollView
    }
    private func getIsSelected(index: IndexPath?) -> (Bool) {
        if let index_ = index {
            return (self.superTableView?.getCellIsSelected(index: index_)) ?? false
        }
        print("🌶\(self)，暂无indexPath,请查看tableview的数据源中，是否给cell的indexPath赋值")
        return false
    }
}
