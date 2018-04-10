![可以扩展的collectionView1.gif](http://upload-images.jianshu.io/upload_images/4185621-9657ddb5259c094e.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 对tableview，基本没有代码侵入，不会影响到你的任何操作，`不过，需要你的tableview，行高自适应`
## 实现思路
>1. 根据flowLayout以及数据源的count来确定collectionView的Height。
>2. 根据每行最多展示数，以及未展最多展示数，来确定collectionView展示函数，以确定collectionView的Height。
>3. 点击展开后，把数据源count显示到最大。并且，改变collectionView的Height。
>4. tableView的复用问题，给tableView添加字典属性，并且把indexPath作为key，记录当前是否为展开状态。
>5. 自定义tableViewCell,来配置collectionView的flowLayout，以及一些其他的属性

---
##主要的类
###一、PYElasticityCollectionView:UIView
>1. 这个里面主要包含一个collectionView，和一个Button。
>2. 管理了collectionView的Height，以及collectionView与Button的布局问题

初始化方法：
 需要一个collectionView的layout，以及collectionView的Button
```
 init(frame: CGRect, cellClass: AnyClass, layout: UICollectionViewFlowLayout) 
```
必须设置这个值，在你的tableview数据源中
```
 var indexPath: IndexPath?
````
数据源
```
modelArray: [Any] = []
```
展示控制
```
   ///未展开的时候最多展示多少条
    var maxShowItem: NSInteger = 0
    ///每一行有多少
    var maxRowItemNum: NSInteger = 1
```
高度
```
    ///当前这个view的高度
    var currentViewH: CGFloat 
    ///当前的 collectionView的高度
    var currentCollectionViewH: CGFloat
```
###二、PYElasticityTableViewCell
**为了配合tableView做的封装**
>里面包含bottomView和topView，自管理collectionView的展开与收起

点击后展开按钮后，父控件是否自动刷新数据(默认是true，如果设置成False，请在tableview中的数据源中用receivedSignalFunc函数监听点击事件，然后自行刷新,注意signalKey为PYElasticityTableViewCell_ClickMoreButton)
```
 var isAutoReloadData: Bool = true
```
 update topViewH，如果在创建self的时候，没有给topViewH，那么请不要用这个来更改topView的高度
```
  var topViewH: CGFloat? = 0 
```
 upDate topViewH， 如果在创建self的时候，没有给bottomViewH，那么请不要用这个来更改bottomView的高度
```
 var bottomViewH: CGFloat? = 0
```
 collectionView的Button
```
var collectionViewBottomButton
```

 配置cell，使得里面有点击按钮可以伸缩的collectionView，《🌶topView与bottomView，自适应🌶》
```
func configurationCollectionViwFunc(layout: UICollectionViewFlowLayout,cellClass: AnyClass,maxShowItem: NSInteger, maxRowItemNum: NSInteger,isHiddenButton: Bool? = false,buttonInstert: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, 0, 0),topView: PYElasticityTopView? = nil, bottomView: PYElasticityBottomView? = nil)
```
配置cell，使得里面有点击按钮可以伸缩的collectionView，《🌶topView与bottomView需要固定高度，不能自适应🌶》
```
func configurationCollectionViwFunc(layout: UICollectionViewFlowLayout,cellClass: AnyClass,maxShowItem: NSInteger, maxRowItemNum: NSInteger,isHiddenButton: Bool? = false,buttonInstert: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, 0, 0),topView: PYElasticityTopView? = nil, bottomView: PYElasticityBottomView? = nil,topViewH: CGFloat? = 0, bottomViewH: CGFloat? = 0)
```
---
## 用法PYElasticityTableViewCell
1. 把tableview设置成自适应行高
 2. 继承自PYElasticityTableViewCell，然后自定义一个传输数据的model接口，
 3. 然后在model的didSet方法里面，你要调用**setUPElasticityCollectionViewDataSourceFunc**这个方法，给collectionView传递数据，
 4. 如果不想点击collectionView下面的按钮后自动让你的tableview刷新，那么可以设置属性isAutoReloadData为False，但是你必须要在tableVIew的数据源中，监听到点击事件，并手动刷新，直接复制粘贴下面代码到数据源中，注意message，是collectionView当前的数据源数组。
`注意，你要把cell的`isAutoReloadData`置位false否则tableView会刷新两次`
```
  ///注意，这句话要写，不然会刷新两次cell.isAutoReloadData = false
  self?.eceivedSignalFunc(eventCallBack: { [weak self](signalKey, message) -> (Any)? in
            if signalKey == PYElasticityTableViewCell_ClickMoreButton {
                /// 你要的点击事件在这里拿到
                self?.reloadData()
            }
            return nil
        })
```
`自适应行高`
```
  //tableview的行高自适应,这个要尽量的接近你的自适应高度
        estimatedRowHeight = kViewCurrentH_XP(H: 500)
 //iOS8之后默认就是这个值，可以省略
       rowHeight = UITableViewAutomaticDimension
````

## collectionViewCell 的分类
解决数据的传输 问题
在collectionViewCell中，调用 `self.setUPDateSourceFunc`  block来接受数据
```
//MARK: - 为cell添加分类
extension UICollectionViewCell {
    var setUPDateSourceCallBack: ((_ model: Any)->())? {
        get {
            return objc_getAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_CellDataSource) as? ((Any) -> ())
        }
        set (newValue) {
            objc_setAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_CellDataSource, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    struct struct_BaseUICollectionViewKey {
        static let k_Cell = UnsafeRawPointer.init(bitPattern:"cell".hashValue)
        static let k_CellDataSource = UnsafeRawPointer.init(bitPattern:"k_CellDataSource".hashValue)
        static let k_CellIndexPath = UnsafeRawPointer.init(bitPattern:"k_CellIndexPath".hashValue)
    }
    var indexPath: NSIndexPath {
        get {
            return objc_getAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_CellIndexPath) as! NSIndexPath
        }
        set (newValue) {
            setUPDateSourceCallBack?(newValue)
            objc_setAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_CellIndexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var model_BaseData_: Any {
        get {
            return objc_getAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_Cell)
        }
        set (newValue) {
            setUPDateSourceCallBack?(newValue)
            objc_setAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_Cell, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    ///collectionViewCell 接受数据 的函数
    func setUPDateSourceFunc(_ setUPDateSourceCallBack: ((_ model: Any)->())?) {
        self.setUPDateSourceCallBack = setUPDateSourceCallBack
    }
}
```

##代码示例
**tableView代码示例**
其实正常写就可以了
```
import UIKit

class PYTableView: UITableView,
UITableViewDelegate,
UITableViewDataSource
{
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUP() {
        self.dataSource = self
        self.delegate = self
        //tableview的行高自适应,这个要尽量的接近你的自适应高度
        estimatedRowHeight = kViewCurrentH_XP(H: 500)
        //iOS8之后默认就是这个值，可以省略
        rowHeight = UITableViewAutomaticDimension
        self.register(PYElasticityTestTCell.classForCoder(), forCellReuseIdentifier: "CELLID")
    }
}

extension PYTableView {
    ///数据原方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELLID", for: indexPath) as! PYElasticityTestTCell
//        cell.isSelect = self.getCellIsSelected(index: indexPath)
        cell.indexPath = indexPath
        cell.modelArray = [
            "不","是","和","还",
        ]
        cell.selectionStyle = .none
        
        cell.backgroundColor = #colorLiteral(red: 0.8520416148, green: 0.9956474186, blue: 1, alpha: 1)
        
        //发送消息
        NSObject.stitchChannelFunc(sender: cell, receiver: self)
        return cell
    }
}
```


**PYElasticityTestTCell: PYElasticityTableViewCell代码示例**
```
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
            self?.topView.label.text = message as! String
        }
    }
    
    var modelArray: [Any]?{
        didSet {
            ///在这里可以对 top View 和 bottom view 的高度约束进行更改
            //            self.topViewH = 200
            //            self.bottomViewH = 300
            
            ///用这个方法来给collectionViewCell传递数据
            self.setCollectionViewData(data: modelArray ?? [])
        }
    }
}
```
## collectionViewCell中 接受传输的数据的方法 
```
  ///collectionViewCell 接受数据 的函数
    func setUPDateSourceFunc(_ setUPDateSourceCallBack: ((_ model: Any)->())?) {
        self.setUPDateSourceCallBack = setUPDateSourceCallBack
    }
```

---
 更新 2018.4.10
- 对代码进行了瘦身。
- 修复了在通过对 `self.topViewH`赋值更新 `topView (bottomView) height` 约束的时候会出现莫名的`bug`。


[示例代码](https://www.jianshu.com/p/fd32ae2c68f4)
