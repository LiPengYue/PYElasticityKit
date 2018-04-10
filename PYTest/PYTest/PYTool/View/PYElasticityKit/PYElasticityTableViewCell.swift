//
//  KROverdueDecorateTBVCell.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/11/9.
//  Copyright © 2017年 koalareading. All rights reserved.
//
//MARK: - ------------------- ~ read me ~ -----------------------
/* 使用：
 1. 继承自PYElasticityTableViewCell，然后自定义一个传输数据的model接口，
 2. 然后在model的didSet方法里面，你要调用*setCollectionViewData*这个方法，给collectionView传递数据，
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
public let PYElasticityTableViewCell_ClickMoreButton = "PYElasticityTableViewCell_ClickMoreButton"
///self中的collectionView，与self背景色相同
class PYElasticityTableViewCell: UITableViewCell {
    //MARK: - 配置属性
    
    ///点击后展开按钮后，父控件是否自动刷新数据(默认是true，如果设置成False，请在tableview中的数据源中用receivedSignalFunc函数监听点击事件，然后自行刷新,注意signalKey为PYElasticityTableViewCell_ClickMoreButton)
    var isAutoReloadData: Bool = true
    
    /// update topViewH，如果在创建self的时候，没有给topViewH，那么请不要用这个来更改topView的高度
    var topViewH: CGFloat? {
        didSet {
            if let topViewH = topViewH {
                topView.snp.updateConstraints({ (make) in
                    make.height.equalTo(topViewH)
                })
            }
        }
    }
    /// upDate topViewH， 如果在创建self的时候，没有给bottomViewH，那么请不要用这个来更改bottomView的高度
    var bottomViewH: CGFloat?  {
        didSet {
            bottomView.snp.updateConstraints({ (make) in
                make.height.equalTo(bottomViewH ?? 0)
            })
        }
    }
    
    ///backgroundView
    var py_backgroundView: UIView {get {return py_backgroundViewPrivate}}
    
    /// 刷新BackGroundView 的margin大小
    var backgroundViewBottomMargin: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0) {
        didSet{
            py_backgroundView.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(backgroundViewBottomMargin.left)
                make.right.equalTo(contentView).offset(backgroundViewBottomMargin.right)
                make.bottom.equalTo(contentView).offset(backgroundViewBottomMargin.bottom)
                make.top.equalTo(contentView).offset(backgroundViewBottomMargin.top)
            }
        }
    }
    
    /// collectionView的Button
    var collectionViewBottomButton: UIButton {
        get {
            return elasticityCollectionView.button
        }
    }
    
    ///必须设置这个值，在你的tableview数据源中
    var indexPath: IndexPath?
    
    ///collectionViewCell中点击事件的接收
    func collectionViewCellEventCallBackFunc(cellEventCallBack: ((_ signal: String, _ message: Any)->())?) {
        self.cellEventCallBack = cellEventCallBack
    }
    
    ///点击了底部的展开按钮
    func clickBottomButtonFunc (_ clickBottomButtonCallBack: ((_ currentH: CGFloat,  _ cell: UITableViewCell)->(IndexPath)?)?) {
        self.clickBottomButtonCallBack = clickBottomButtonCallBack
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
    ///   - topViewH: topView的高度: 1. 如果设置了topViewH，可以通过 对self.topViewH赋值来更改topView的高度 2.如果选择没有赋值，那么就要在TopView中设置自适应约束 来撑开 topView
    ///   - bottomViewH: 同topViewH
    func configurationCollectionViwFunc(layout: UICollectionViewFlowLayout,
                                        cellClass: AnyClass,maxShowItem: NSInteger,
                                        maxRowItemNum: NSInteger,
                                        isHiddenButton: Bool? = false,
                                        buttonInstert: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, 0, 0),
                                        topView: PYElasticityTopView? = nil,
                                        bottomView: PYElasticityBottomView? = nil,
                                        topViewH: CGFloat? = 0,
                                        bottomViewH: CGFloat? = 0) {
        
        elasticityCollectionViewLayout = layout
        elasticityCollectionViewCellClass = cellClass
        elasticityCollectionView.maxShowItem = maxShowItem
        elasticityCollectionView.maxRowItemNum = maxRowItemNum
        elasticityCollectionView.isHiddenButton = isHiddenButton ?? false
        elasticityCollectionView.buttonInsets = buttonInstert ?? UIEdgeInsetsMake(0, 0, 0, 0)
        self.bottomView = bottomView ?? PYElasticityBottomView()
        self.topView = topView ?? PYElasticityTopView()
        isAddRestrainBotttomHeight = bottomViewH != nil
        isAddRestrainTopViewHeight = topViewH != nil
        
        registerEvent()
        /// 由于要先有约束 才能对其进行update 所以 要在topViewH 与 bottomViewH 赋值之间进行约束
        setUPView()
        if let topViewH = topViewH {self.topViewH = topViewH}
        if let bottomViewH = bottomViewH {self.bottomViewH = bottomViewH}
        
    }
    
    //MARK: - 私有属性
    private var collectionViewModelArray: [Any] = []
    private lazy var elasticityCollectionView: PYElasticityCollectionView = {
        let elasticityCollectionView = PYElasticityCollectionView(frame: CGRect.zero, cellClass: self.elasticityCollectionViewCellClass, layout: self.elasticityCollectionViewLayout)
        return elasticityCollectionView
    }()
    
    private var topView: PYElasticityTopView = PYElasticityTopView()
    private var bottomView: PYElasticityBottomView = PYElasticityBottomView()
    private weak var superTableView: UITableView?
    
    private var elasticityCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var elasticityCollectionViewCellClass: AnyClass = UICollectionViewCell.classForCoder()
    private var py_backgroundViewPrivate: UIView = UIView()
    
    private var isAddRestrainTopViewHeight: Bool = false
    private var isAddRestrainBotttomHeight: Bool = false
    
    ///MAKR: 点击事件的注册
    var clickBottomButtonCallBack: ((_ currentH: CGFloat,  _ cell: UITableViewCell)->(IndexPath)?)?
    ///collectionViewCell中点击事件的接收
    private var cellEventCallBack: ((_ signal: String, _ message: Any)->())?
    
    
    //MARK: - 向collectionView Cell 传递数据 的方法
    ///向collectionView Cell 传递数据 的方法
    func setCollectionViewData(data Data: [Any]) {
        elasticityCollectionView.isSelected = self.getIsSelected(index: indexPath)
        elasticityCollectionView.modelArray = Data
        let changeNameH =  elasticityCollectionView.currentViewH
        self.elasticityCollectionView.snp.updateConstraints { (make) in
            make.height.equalTo(changeNameH)
        }
    }
    
    
    //MARK: - setup View
    private func setUPView() {
        
        contentView.addSubview(py_backgroundView)
        py_backgroundView.addSubview(elasticityCollectionView)
        py_backgroundView.addSubview(topView)
        py_backgroundView.addSubview(bottomView)
        
        py_backgroundView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(contentView)
        }
        
        let elasticityCollectionViewH = elasticityCollectionView.currentViewH
        layoutTopView()
        elasticityCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(py_backgroundView).offset(kViewCurrentW_XP(W: 0))
            make.right.equalTo(py_backgroundView).offset(kViewCurrentW_XP(W: 0))
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(elasticityCollectionViewH)
        }
        layoutBottomView()
    }
    
    /// topView 约束
    private func layoutTopView() {
        /// 需要添加 topView 的高度约束
        if isAddRestrainTopViewHeight {
            topView.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(py_backgroundView)
                make.height.equalTo(topViewH ?? 0)
            })
            return
        }
        topView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(py_backgroundView)
            make.bottom.equalTo(elasticityCollectionView.snp.top)
        })
        
    }
    
    /// bottomView 约束 设置
    private func layoutBottomView() {
        if isAddRestrainBotttomHeight {
            bottomView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(py_backgroundView)
                make.top.equalTo(elasticityCollectionView.snp.bottom)
                make.height.equalTo(bottomViewH ?? 0)
            })
            return
        }
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(elasticityCollectionView.snp.bottom)
            make.left.right.bottom.equalTo(py_backgroundView)
        })
        
    }
    
    private func registerEvent() {
        /// 事件的传递
        elasticityCollectionView.receivedSignalFunc {[weak self] (signal, message) -> (Any)? in
            self?.cellEventCallBack?(signal,message)
            return self?.sendSignalFunc(signalKey: signal, message: message)
        }
        
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
    
    
    //MARK: 关于 父控件 的获取 以及是否展开状态的判断
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superTableView = getScrollView(self)
    }
    
    /// 获取父控件 tableView
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
    
    ///是否为选中状态
    private func getIsSelected(index: IndexPath?) -> (Bool) {
        if let index_ = index {
            return (self.superTableView?.getCellIsSelected(index: index_)) ?? false
        }
        print("🌶\(self)，暂无indexPath,请查看tableview的数据源中，是否给cell的indexPath赋值")
        return false
    }
}

