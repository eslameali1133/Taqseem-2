//
//  CahtCell.swift
//  Taqseem
//
//  Created by apple on 2/17/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class CahtCell: UITableViewCell {

    
    @IBOutlet weak var lbl_chatCounter: UILabel!{
        didSet{
            lbl_chatCounter.layer.cornerRadius = lbl_chatCounter.frame.width / 2
            lbl_chatCounter.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgLabel: customImageView!{
        didSet{
            imgLabel.layer.cornerRadius =  imgLabel.frame.width / 2
            imgLabel.layer.borderWidth = 1
            imgLabel.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
