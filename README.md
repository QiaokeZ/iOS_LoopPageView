# iOS_LoopPageView
### 简书(https://www.jianshu.com/p/ae1b84b107ea)
 ![image](https://github.com/QiaokeZ/iOS_LoopPageView/blob/master/LoopPageViewDome/LoopPageViewDome/dome.gif)

```swift
class VerticalViewController: UIViewController {

    private let itemCount = 10
    private var loopPageView:LoopPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        
        loopPageView = LoopPageView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 100)),
                                    direction: .vertical,
                                    itemClass: LoopPageViewCell.self)
        loopPageView.delegate = self
        loopPageView.dataSource = self
        loopPageView.waitTimeInterval = 1
        view.addSubview(loopPageView)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: loopPageView.frame.maxY + 20, width: 130, height: 40)
        label.text = "是否自动滑动"
        view.addSubview(label)
        
        let aSwitch = UISwitch()
        aSwitch.tag = 1
        aSwitch.frame.origin = CGPoint(x: label.frame.maxX, y: label.frame.origin.y)
        aSwitch.addTarget(self, action: #selector(VerticalViewController.switchValueChanged), for: .valueChanged)
        view.addSubview(aSwitch)
        
        let label1 = UILabel()
        label1.frame = CGRect(x: 0, y: label.frame.maxY + 20, width: 130, height: 40)
        label1.text = "允许手势滑动"
        view.addSubview(label1)
        
        let aSwitch1 = UISwitch()
        aSwitch1.isOn = true
        aSwitch1.tag = 2
        aSwitch1.frame.origin = CGPoint(x: label1.frame.maxX, y: label1.frame.origin.y)
        aSwitch1.addTarget(self, action: #selector(VerticalViewController.switchValueChanged), for: .valueChanged)
        view.addSubview(aSwitch1)
    }
    
    @objc func switchValueChanged(aSwitch: UISwitch){
        if aSwitch.tag == 1{
              loopPageView.isAutoScroll = aSwitch.isOn
        }
        if aSwitch.tag == 2{
            loopPageView.isScrollEnabled = aSwitch.isOn
        }
    }
}

extension VerticalViewController:LoopPageViewDataSource,LoopPageViewDelegate{
    
    func numberOfRows(in loopPageView: LoopPageView) -> Int {
        return itemCount
    }
    
    func loopPageView(_ loopPageView: LoopPageView, willDisplay cell: UICollectionViewCell, forItemAt index: Int) {
        guard let itemCell  = cell as? LoopPageViewCell else {
            return
        }
        itemCell.titleLabel.text = "\(index)"
        
    }
    
    func loopPageView(_ loopPageView: LoopPageView, didSelectItem index: Int) {
        print("点击了\(index)")
    }
    
    func loopPageView(_ loopPageView: LoopPageView, scrollViewDidScroll scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.y / scrollView.bounds.size.height + 0.5) % itemCount
        print("滑动到\(index)")
    }
}

```