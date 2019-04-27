//
//  menuCell.swift
//  Taqseem
//
//  Created by apple on 2/18/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class menuCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lbl_2: UILabel!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
