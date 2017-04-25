//
//  BaseTableViewCell.swift
//  app_005
//
//  Created by Abhi Dutta on 16/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BaseTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImageView: PFImageView!    
    @IBOutlet weak var upvoteCounter: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var suburbLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

}
