//
//  RequestPlayerCell.swift
//  Taqseem
//
//  Created by Husseinomda16 on 3/19/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class RequestPlayerCell: UITableViewCell {
    var playerID = ""
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var imgPlayer: customImageView!{
        didSet{
            imgPlayer.layer.cornerRadius =  imgPlayer.frame.width / 2
            imgPlayer.layer.borderWidth = 1
            //            ProfileImageView.layer.borderColor =  UIColor(red: 0, green: 156, blue: 158, alpha: 1) as! CGColor
            
            imgPlayer.clipsToBounds = true
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnChat(_ sender: Any) {
        
        let SelectedPlay = User(
            user_id:playerID ,
            from: lblPlayerName.text!
        )
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "ChatpageVC")as! ChatpageVC
        print(SelectedPlay)
        cont.SelectedPlayer = SelectedPlay
        let currentController = self.getCurrentViewController()
        currentController?.present(cont, animated: true, completion: nil)
    }
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
