//
//  KRBaseView_CollectionView.swift
//  KoalaReadingTeacher
//
//  Created by 李鹏跃 on 2017/8/31.
//  Copyright © 2017年 Koalareading. All rights reserved.
//

import UIKit
import SnapKit
///里面有一个collectionView，一个Button，可以展开，
class PYElasticityCollectionView:UIView,
UICollectionViewDelegate,
UICollectionViewDataSource
{
    let CELLID = "CELLID"
    
    init(frame: CGRect, cellClass: AnyClass, layout: UICollectionViewFlowLayout) {
        self.isSelected = false
        super.init(frame: frame)
        self.layout = layout
        self.cellClass = cellClass
        show()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 属性设置
    ///底部的展开按钮
    var button = UIButton()
    ///数据源
    var modelArray: [Any] = [] {
        didSet {
            self.isHiddenButton = modelArray.count <= self.maxShowItem
            if let collectionView_ = collectionView {
                collectionView_.snp.updateConstraints{ (make) in
                    make.height.equalTo(currentCollectionViewH)
                }
                collectionView.reloadData()
            }
        }
    }
    ///未展开的时候最多展示多少条
    var maxShowItem: NSInteger = 0
    ///每一行有多少
    var maxRowItemNum: NSInteger = 1
    ///collectionView 的layout
    var layout = UICollectionViewFlowLayout()
    
    var isHiddenButton: Bool = false {
        didSet {
            setUPHiddenButton()
        }
    }
    ///button 的上下左右的 间距
    var buttonInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            setButtonInset()
        }
    }
    
    ///button 的高度
    var buttonH: CGFloat {
        get {   
            return buttonH_
        }
        set {
            buttonH_ = newValue
        }
    }
   
    ///点击底部的按钮
    var clickBottomButtonCallBack: ((_ currentH: CGFloat)->(IndexPath)?)?
    func clickBottomButtonFunc (_ clickBottomButtonCallBack: ((_ currentH: CGFloat)->(IndexPath)?)?) {
        self.clickBottomButtonCallBack = clickBottomButtonCallBack
    }
    
    //展示的数据条数
    var trueShowItemNum: NSInteger {
        get {
         return getTrueNumb()
        }
    }
    /// cell 的类型
    var cellClass: Swift.AnyClass?
    /// 是否为点击状态
    var isSelected: Bool {
        didSet {
            button.isSelected = isSelected
        }
    }
    
    ///当前这个view的高度
    var currentViewH: CGFloat {
        get {
            return getCurrentViewH()
        }
    }
    ///当前的 collectionView的高度
    var currentCollectionViewH: CGFloat {
        get {
            return getCurrentCollectionViewH()
        }
    }
    
    private var buttonH_: CGFloat = kViewCurrentH_XP(H: 70)
    private var collectionView: UICollectionView!
    ///父视图的记录
    private weak var scrollView: UIScrollView? {
        get {
            return self.getScrollView(self)
        }
    }
    private weak var cell: UIView? {
        get {
            return self.getCell(self)
        }
    }
    private weak var cell_: UIView?
    private weak var scrollView_: UIScrollView?
    
    private func show() {
        setUP()
    }
    
    private func setUP() {
        self.setUPValue()
        self.setUPFrame()
        collectionView.reloadData()
        collectionView.backgroundColor = self.backgroundColor
    }
    
    private func setUPValue() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellClass, forCellWithReuseIdentifier:CELLID)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    private func setUPFrame() {
        
        self.addSubview(collectionView)
        self.addSubview(button)
    
        let currentViewHRound = (currentCollectionViewH)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(currentViewHRound)
            make.bottom.equalTo(self).offset(-buttonInsets.bottom - buttonInsets.top - buttonH)
        }
        button.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(buttonInsets.left)
            make.right.equalTo(self).offset(-buttonInsets.right)
            make.height.equalTo(buttonH)
            make.bottom.equalTo(self).offset(buttonInsets.bottom)
        }
    }
  
   
    //点击事件的相应
    @objc private func clickButton(_ button: UIButton) {
        collectionView.snp.updateConstraints{ (make) in
            make.height.equalTo(currentCollectionViewH)
        }
        self.indexPath = clickBottomButtonCallBack?((currentViewH))
        collectionView.reloadData()
    }
    private var indexPath: IndexPath?
//    var isFirstCallBack = true
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonPoint = self.convert(point, to: button)
        if button.point(inside: buttonPoint, with: event) {
            return button
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: -
    private func setUPHiddenButton() {
        self.button.isHidden = isHiddenButton
        if isHiddenButton {
            button.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(buttonInsets.left)
                make.right.equalTo(self).offset(-buttonInsets.right)
                make.height.equalTo(0)
            }
            collectionView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self).offset(0)
            }
        }else{
            button.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(buttonInsets.left)
                make.right.equalTo(self).offset(-buttonInsets.right)
                make.height.equalTo(buttonH)
            }
            collectionView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self).offset(-buttonInsets.bottom - buttonInsets.top - buttonH)
            }
        }
    }
    
    private func setButtonInset() {
        button.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(buttonInsets.left)
            make.right.equalTo(self).offset(-buttonInsets.right)
            make.bottom.equalTo(self).offset(buttonInsets.bottom)
        }
        collectionView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self).offset(-buttonInsets.bottom - buttonInsets.top - buttonH)
        }
    }
    
    private func getTrueNumb()->(NSInteger) {
        if isHiddenButton {
            return modelArray.count
        }
        if isSelected {
            return modelArray.count
        }
        if maxShowItem < 0 {
            return modelArray.count
        }
        if modelArray.count > maxShowItem {
            return maxShowItem / maxRowItemNum * maxRowItemNum
        }
        return modelArray.count
    }
    private func getCurrentCollectionViewH() -> (CGFloat) {
        let itmeH = layout.itemSize.height
        var margin: CGFloat = 0.0
        var secionHeiderH: CGFloat = 0.0
        var secionFootH: CGFloat = 0.0
        var rightLeftW: CGFloat = 0.0
        ///
        //minimumLineSpacing
        if layout.scrollDirection == .horizontal {
            margin = layout.minimumInteritemSpacing
            rightLeftW = layout.minimumLineSpacing
            secionHeiderH = layout.sectionInset.top
            secionFootH = layout.sectionInset.bottom
        }else {
            margin = layout.minimumLineSpacing
            rightLeftW = layout.minimumInteritemSpacing
            secionHeiderH = layout.sectionInset.left
            secionFootH = layout.sectionInset.right
        }
        //一共多少排
        //计算一排有多少个
        if trueShowItemNum == 0 {
            return 0
        }
        var row = CGFloat(trueShowItemNum) / CGFloat(maxRowItemNum)
        let rowIsSeleted = isSelected ? ceil(row) : floor(row)
        row = isHiddenButton ? ceil(row) : rowIsSeleted
        return  (CGFloat(row - 1) * margin) + (CGFloat(row) * itmeH) + secionFootH + secionHeiderH
    }
    private func getCurrentViewH() -> (CGFloat) {
        let notHiddenButtonViewH = (currentCollectionViewH + buttonH + buttonInsets.top + buttonInsets.bottom)
        let hiddenButtonViewH = (currentCollectionViewH)
        return isHiddenButton ? hiddenButtonViewH : notHiddenButtonViewH
    }
}

//MARK: - dataSource
extension PYElasticityCollectionView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trueShowItemNum
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID, for: indexPath)
        cell.model_BaseData_ = self.modelArray[indexPath.row]
        cell.receivedSignalFunc { [weak self] (signalKey, massage) -> (Any)? in
            self?.sendSignalFunc(signalKey: signalKey, message: massage)
        }
        return cell
      
    }
}

extension PYElasticityCollectionView {
    func getScrollView(_ view: UIView) -> (UIScrollView) {
        if self.scrollView_ != nil {
            return self.scrollView_!
        }
        if view is UITableView {
            self.scrollView_ = view as! UIScrollView
            return view as! UIScrollView
        }
        if view.superview == nil {
            print("🌶 \\getScrollView(_ view: UIView) -> (UIScrollView)\\ superView为nil")
            return UIScrollView()
        }
        let scrollView = self.getScrollView(view.superview!)
        return scrollView
    }
    func getCell(_ view: UIView) -> (UIView) {
        if self.cell_ != nil {
            return self.cell_!
        }
        if view is UITableViewCell {
            cell_ = view
            return view
        }
        if view.superview == nil {
            print("🌶 \\getCell(_ view: UIView) -> (UIView)\\ superView为nil")
            return UIView()
        }
        let cell = self.getCell(view.superview!)
        return cell
    }
}
