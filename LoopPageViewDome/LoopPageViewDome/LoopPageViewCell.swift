//
//  LoopPageViewCell.swift
//  LoopPageViewDome
//
//  Created by admin on 2019/3/1.
//  Copyright © 2019 zhouqiao. All rights reserved.
//

import UIKit

class LoopPageViewCell: UICollectionViewCell {

    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
}
