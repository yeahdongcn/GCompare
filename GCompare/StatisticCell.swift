//
//  StatisticCell.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/18.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit

class StatisticCell: UICollectionViewCell {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        valueLabel.alpha = 0
    }
}
