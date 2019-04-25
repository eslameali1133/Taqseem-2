//
//  ChoosebackgroundCell.swift
//  Taqseem
//
//  Created by apple on 2/24/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class ChoosebackgroundCell: UITableViewCell {
    
    var http = HttpHelper()
    var MatchDetails : MatchDetailsModelClass!
    var items : PlaygroundModelClass!
    var NearItems : NearPlayGroundModelClass!
    @IBOutlet weak var imgGround: customImageView!{
        didSet{
            
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgStar: AMCircleImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewcontent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        http.delegate = self
        // Initialization code
        viewcontent.dropShadow()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnAddToFavourites(_ sender: Any) {
        Add()
    }
    
    func Add(){
        
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        var params = [:] as [String: Any]
        
        if comedromneartoplay == "NearME"{
        params = [
            "ground_id":NearItems._id
            ] as [String: Any]
        }else{
        params = [
            "ground_id":items._id
            ] as [String: Any]
        }
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
            "lang":SharedData.SharedInstans.getLanguage(),
            "Authorization": "\(token_type) \(AccessToken)"
        ]
        
        let currentController = self.getCurrentViewController()
        
        AppCommon.sharedInstance.ShowLoader((currentController?.view)!,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.AddToFav, method: .post, parameters: params, tag: 1, header: headers)
        
    }
    
    @IBAction func btnChoose(_ sender: Any) {
        if comedromneartoplay == "NearME"
                {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                    let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchVC")as! MyMatchVC


                    cont.NearItems = NearItems
                    let currentController = self.getCurrentViewController()
                    currentController?.present(cont, animated: true, completion: nil)

                }else{
        
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                    let cont = storyBoard.instantiateViewController(withIdentifier: "playGroundDetailsVC")as! playGroundDetailsVC
        
                    cont.item = items
                    cont.MatchDetails = MatchDetails
            let currentController = self.getCurrentViewController()
            currentController?.present(cont, animated: true, completion: nil)
        
               }
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
    
    
    }
extension ChoosebackgroundCell: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        
        if Tag == 1 {
            print(dictResponse)
           
           
            let currentController = self.getCurrentViewController(); AppCommon.sharedInstance.dismissLoader((currentController?.view)!)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
            
            if status.stringValue == "1" {
                
                if message == "favorite success"{
                    imgStar.image = UIImage(named: "star-2")
                }
                if message == "unfavorite success"{
                    imgStar.image = UIImage(named: "star-1")
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
