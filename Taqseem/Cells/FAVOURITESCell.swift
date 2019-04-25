//
//  FAVOURITESCell.swift
//  Taqseem
//
//  Created by apple on 2/18/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class FAVOURITESCell: UITableViewCell {
    var http = HttpHelper()
   // var MatchDetails : MatchDetailsModelClass!
    var FavItems : NearPlayGroundModelClass!
    @IBOutlet weak var imgGround: customImageView!{
        didSet{
            
        }
    }
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblGroundName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        http.delegate = self
        // Initialization code
    }

    @IBAction func btnDeleteFav(_ sender: Any) {
        DeleteFav()
    }
    
    func DeleteFav() {
        print(SharedData.SharedInstans.getLanguage())
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        let params = [
            "ground_id":FavItems._id
            ] as [String: Any]
        
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
        ]
        
        let currentController = self.getCurrentViewController()
        
        AppCommon.sharedInstance.ShowLoader((currentController?.view)!,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.AddToFav, method: .post, parameters: params, tag: 1, header: headers)
    }
    
    @IBAction func btnChoose(_ sender: Any) {
        comedromneartoplay = "Fav"
        let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "playGroundDetailsVC")as! playGroundDetailsVC
        
        cont.FavItem = FavItems
       // cont.MatchDetails = MatchDetails
        
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
extension FAVOURITESCell: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        
        if Tag == 1 {
            print(dictResponse)
            
            
            let currentController = self.getCurrentViewController(); AppCommon.sharedInstance.dismissLoader((currentController?.view)!)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
            
            if status.stringValue == "1" {
                
                
                if message == "unfavorite success"{
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                    let cont = storyBoard.instantiateViewController(withIdentifier: "FavaVC")as! FavaVC
                    
                    
                    
                    let currentController = self.getCurrentViewController()
                   
                    currentController?.present(cont, animated: true, completion: nil)
                 }
                Loader.showSuccess(message: message.stringValue)
            } else {
                
                Loader.showError(message: message.stringValue )
            }
        }
        
    }
    func receivedErrorWithStatusCode(statusCode: Int) {
        print(statusCode)
        let currentController = self.getCurrentViewController();
        AppCommon.sharedInstance.alert(title: "Error", message: "\(statusCode)", controller: (currentController)!, actionTitle: AppCommon.sharedInstance.localization("ok"), actionStyle: .default)
        
        AppCommon.sharedInstance.dismissLoader((currentController?.view)!)
    }
    func retryResponse(numberOfrequest: Int) {
        
    }
}

