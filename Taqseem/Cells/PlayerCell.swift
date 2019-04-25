//
//  PlayerCell.swift
//  Taqseem
//
//  Created by Husseinomda16 on 2/20/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class PlayerCell: UITableViewCell {
    var PlayerID = ""
    @IBOutlet weak var lblPlayerName: UILabel!
     @IBOutlet weak var BtnDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnChatt(_ sender: Any) {
        let SelectedPlay = User(
            user_id:PlayerID ,
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
    
    @IBAction func btnChat(_ sender: Any) {
        let SelectedPlay = User(
            user_id:PlayerID ,
            from: lblPlayerName.text!
        )
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "ChatpageVC")as! ChatpageVC
        print(SelectedPlay)
        cont.SelectedPlayer = SelectedPlay
        let currentController = self.getCurrentViewController()
        currentController?.present(cont, animated: true, completion: nil)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
//        DeleteMember()
    }
    
    
    func DeleteMember ()
    {
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
         print(AccessToken)
       // let params = ["member_id":PlayerID] as [String: Any]
        
//        let headers = [
//            "Accept-Type": "application/json" ,
//            "Content-Type": "application/json" ,
//            "Authorization": "\(token_type) \(AccessToken)"
//        ]

        print(PlayerID)
        guard let urll = URL(string: APIConstants.DeleteMember) else {
            print("error url")
            return
        }
        var urlreq = URLRequest(url: urll)
        urlreq.httpMethod = "DELETE"
        urlreq.setValue("application/json", forHTTPHeaderField: "Accept-Type")
        urlreq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlreq.setValue("\(token_type) \(AccessToken)", forHTTPHeaderField: "Authorization")
        
        let jsondic = NSMutableDictionary()
        jsondic.setValue(PlayerID, forKey: "member_id")
        let jsondata : Data
        do {
            jsondata = try JSONSerialization.data(withJSONObject: jsondic, options: JSONSerialization.WritingOptions())
            urlreq.httpBody = jsondata
        }catch{
            print("error Json")
        }
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlreq, completionHandler: {(data : Data? , response : URLResponse? , error : Error?)in
            
            print(response)
            print(data)
        })
        task.resume()
        
           }
        }


