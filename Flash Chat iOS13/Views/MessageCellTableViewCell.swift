//
//  MessageCellTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Nguyen Hoang on 6/3/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
