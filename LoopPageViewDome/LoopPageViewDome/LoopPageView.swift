//
//  LoopPageView.swift
//  LoopPageView <https://github.com/QiaokeZ/iOS_LoopPageView>
//
//  Created by admin on 2019/3/1
//  Copyright © 2019 zhouqiao. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

protocol LoopPageViewDelegate: NSObjectProtocol {
    func loopPageView(_ loopPageView: LoopPageView, willDisplay cell: UICollectionViewCell, forItemAt index: Int)
    func loopPageView(_ loopPageView: LoopPageView, didSelectItem index: Int)
    func loopPageView(_ loopPageView: LoopPageView, scrollViewDidScroll scrollView:UIScrollView)
}

protocol LoopPageViewDataSource: NSObjectProtocol{
    func numberOfRows(in loopPageView: LoopPageView) -> Int
}

class LoopPageView: UIView {

    weak var delegate: LoopPageViewDelegate?
    weak var dataSource: LoopPageViewDataSource?
    
    private(set) var direction: UICollectionView.ScrollDirection = .horizontal
    private(set) var itemClass: AnyClass!
    private(set) var selectedIndex: Int = 0

    private let reuseIdentifier = "LoopPageView"
    private let sectionCount: Int = 5000
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var timer: Timer!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(frame: CGRect, direction: UICollectionView.ScrollDirection, itemClass: AnyClass) {
        super.init(frame: frame)
        self.direction = direction
        self.itemClass = itemClass
        prepare()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeTimer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = frame.size
        collectionView.frame = bounds
    }

    var waitTimeInterval: TimeInterval = 2 {
        willSet {
            if newValue != waitTimeInterval, isAutoScroll {
                removeTimer()
                addTimer()
            }
        }
    }

    var isAutoScroll: Bool = false {
        willSet {
            if newValue != isAutoScroll {
                if newValue {
                    addTimer()
                } else {
                    removeTimer()
                }
            }
        }
    }
    
    var isScrollEnabled: Bool = true{
        willSet {
            if newValue != isScrollEnabled {
                collectionView.isScrollEnabled = newValue
            }
        }
    }
    
    func reloadData(){
        collectionView.reloadData()
    }
}

extension LoopPageView {

    private func prepare() {
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = direction
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(itemClass, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        addSubview(collectionView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.sectionCount / 2),
                at: self.direction == .vertical ? .centeredVertically : .centeredHorizontally,
                animated: false)
        }
    }

    private func addTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: waitTimeInterval,
                target: self,
                selector: #selector(LoopPageView.nextPage),
                userInfo: nil,
                repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        }
    }

    private func removeTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    @objc private func nextPage() {
        guard var indexPath = collectionView.indexPathsForVisibleItems.last else {
            return
        }
        if indexPath.item + 1 == dataSource?.numberOfRows(in: self){
            indexPath = IndexPath(item: 0, section: indexPath.section + 1)
        } else {
            indexPath.item = indexPath.item + 1
        }
        collectionView.scrollToItem(at: indexPath, at: direction == .vertical ? .centeredVertically : .centeredHorizontally, animated: true)
    }
}

extension LoopPageView: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.random
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.loopPageView(self, willDisplay: cell, forItemAt: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.loopPageView(self, didSelectItem: indexPath.row)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutoScroll {
            removeTimer()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isAutoScroll {
            addTimer()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.loopPageView(self, scrollViewDidScroll: scrollView)
    }
}
