//
//  RequestDetailsVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 3/6/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class RequestDetailsVC: UIViewController {
    var items : RequestListModelClass!
    var Status = ""
    var http = HttpHelper()
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var imgUser: customImageView!{
        didSet{
            imgUser.layer.cornerRadius =  imgUser.frame.width / 2
            imgUser.layer.borderWidth = 1
            //            ProfileImageView.layer.borderColor =  UIColor(red: 0, green: 156, blue: 158, alpha: 1) as! CGColor
            
            imgUser.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblGroundName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        http.delegate = self
        SetData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnReject(_ sender: Any) {
        Status = "REJECTED"
        ChangeStatus()
    }
    @IBAction func btnAccept(_ sender: Any) {
        Status = "ACCEPTED"
        ChangeStatus()
    }
    @IBAction func btn_player(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "OwnerRequestPlayersVC")as! OwnerRequestPlayersVC
        cont.ReservationNum = items._reservation_no
        self.present(cont, animated: true, completion: nil)
        
        
    }
    
    func ChangeStatus(){
    print(items._reservation_no)
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        let params = [
            "reservation_no":items._reservation_no ,
            "status" : Status] as [String: Any]
       
        let headers = [
        "Accept-Type": "application/json" ,
        "Content-Type": "application/json" ,
           "lang":SharedData.SharedInstans.getLanguage() ,
        "Authorization" : "\(token_type) \(AccessToken)"
        ]
        
    AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
    http.requestWithBody(url: APIConstants.ChangeStatus, method: .post, parameters: params, tag: 1, header: headers)
    
    }
    func SetData(){
        lblGroundName.text = items._ground_name
        lblTime.text = items._time
        lblDate.text = items._date
        lblCapacity.text = "\(items._capacity) Players"
        lblDuration.text = "\(items._duration) Hours"
        lblUserName.text = items._user_name
        imgUser.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(items._photo)")
        Status = items._reservation_status
        
       if (Status == "ACCEPTED") || (Status == "REJECTED"){
             viewButtons.isHidden = true
        }
    }
}
extension RequestDetailsVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        if Tag == 1 {
            
            let status =  json["status"]
            let message = json["message"]
            
            if status.stringValue == "1" {
                Loader.showSuccess(message: message.stringValue)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "RequestListVC")as! RequestListVC
                print(Status)
                cont.RequestStatus = Status
                
                self.dismiss(animated: false, completion: nil)
//                self.present(cont, animated: true, completion: nil)

            } else {
                
                let message = json["message"]
                Loader.showError(message: message.stringValue )
            }
        }
        
    }
    func receivedErrorWithStatusCode(statusCode: Int) {
        print(statusCode)
        AppCommon.sharedInstance.alert(title: "Error", message: "\(statusCode)", controller: self, actionTitle: AppCommon.sharedInstance.localization("ok"), actionStyle: .default)
        
        AppCommon.sharedInstance.dismissLoader(self.view)
    }
    func retryResponse(numberOfrequest: Int) {
        
    }
}
