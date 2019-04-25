//
//  OwnerHomeVC.swift
//  Taqseem
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
var GlobalGroundDetails : PlaygroundModelClass!
class OwnerHomeVC: UIViewController {

    var http = HttpHelper()
    var items = [PlaygroundModelClass]()
    var itemSelectedid:[Int] = []
    
    
    @IBOutlet weak var TBL_Playground: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comedromneartoplay = ""
        http.delegate = self
        TBL_Playground.dataSource = self
        TBL_Playground.delegate = self
        TBL_Playground.changeView()
        SocketManger.shared.connect()
        //        SocketManger.shared.handleNewMessage { (message) in
        //        }
        SocketManger.shared.handleNotificationMessage { (message) in
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GisNewnotification == true {
            GisNewnotification = false
            self.tabBarController?.selectedIndex = 1
        }else{
            fillData()
            
        }
    }
    
    
    func fillData()  {
        items.removeAll()
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print(token_type , AccessToken)
        print(AccessToken)
        let headers: HTTPHeaders = ["Authorization" : "\(token_type) \(AccessToken)",
           "lang":SharedData.SharedInstans.getLanguage() ]
        http.Get(url: "\(APIConstants.GetGround)", Tag: 2, headers: headers)
    }
    
}


extension OwnerHomeVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        
         if Tag == 2 {
            print(dictResponse)
            AppCommon.sharedInstance.dismissLoader(self.view)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
            print(status)
            print(json["status"])
            if status.stringValue  == "1" {
                let result =  json["data"].arrayValue
                for json in result{
                print(json["days"].arrayValue)
                    var str:[String] = []
                    if json["days"].array!.count > 0
                    {
                    for i in json["days"].array!{
                        str.append(i.stringValue)
                    }
                    }
                    print(str.joined(separator: ","))
                   
                    let obj = PlaygroundModelClass(
                        owner_id: json["owner_id"].stringValue,
                        updated_at: json["updated_at"].stringValue,
                        name: json["name"].stringValue,
                        lng: json["lng"].stringValue,
                        hour_to: json["hour_to"].stringValue,
                        phone: json["phone"].stringValue,
                        image: json["image"].stringValue,
                        note: json["note"].stringValue,
                        lat: json["lat"].stringValue,
                        capacity: json["capacity"].stringValue,
                        address: json["address"].stringValue,
                        name_en: json["name_en"].stringValue,
                        city_id: json["city_id"].stringValue,
                        id: json["id"].stringValue,
                        name_ar: json["name_ar"].stringValue,
                        created_at: json["created_at"].stringValue,
                        hour_from: json["hour_from"].stringValue,
                        cancel_fee: json["cancel_fee"].stringValue,
                        price: json["price"].stringValue,
                        cancelation_time: json["cancelation_time"].stringValue,
                        days:str.joined(separator: ","),
                        matches: json["matches"].stringValue)
                    items.append(obj)
                }
                TBL_Playground.reloadData()
            } else {
                Loader.showError(message: message.stringValue)
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


extension OwnerHomeVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaygroundHomeCell", for: indexPath) as! PlaygroundHomeCell
        cell.contentview.dropShadow()
        cell.lblName.text = items[indexPath.row]._name
        cell.Ground_ID = items[indexPath.row]._id
        cell.lblCapacity.text = items[indexPath.row]._capacity
        cell.lblPrice.text = items[indexPath.row]._price
        cell.imgGround.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(items[indexPath.row]._image)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "OwnerMatchDetailsVC")as! OwnerMatchDetailsVC
        cont.items = items[indexPath.row]
        GlobalGroundDetails = items[indexPath.row]
        self.present(cont, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
