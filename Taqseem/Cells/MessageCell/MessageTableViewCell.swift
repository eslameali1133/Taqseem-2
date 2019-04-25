//
//  IncomingMessageTableViewCell.swift
//  SocketChatiOS
//
//  Created by Chhaileng Peng on 12/20/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarLabel.layer.masksToBounds = true
        avatarLabel.layer.cornerRadius = 16
        
        messageView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message: MessageModelClass) {
       print(message)
        avatarLabel.text = "\(message._username.uppercased()[0])"
        usernameLabel.text = message._username
        messageLabel.text = message._message
    }
    //Group message configureCell
    func configureCell(message: GroupMessageModelClass) {
       // print(message)
        avatarLabel.text = "\(message._from.uppercased()[0])"
        usernameLabel.text = message._from
        messageLabel.text = message._message
    }

}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
