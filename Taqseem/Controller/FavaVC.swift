//
//  FavaVC.swift
//  Taqseem
//
//  Created by apple on 2/18/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class FavaVC: UIViewController {
@IBOutlet weak var TBL_FAV: UITableView!
    //var items = [PlaygroundModelClass]()
    var FavItem = [NearPlayGroundModelClass]()
    //var MatchDetais : MatchDetailsModelClass!
    var http = HttpHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        http.delegate = self
        TBL_FAV.dataSource = self
        TBL_FAV.delegate = self
        TBL_FAV.changeView()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func DismissView(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        Filter()
    }

    func Filter() {
        FavItem.removeAll()
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print(token_type , AccessToken)
        print(AccessToken)
        let headers: HTTPHeaders = ["Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage() ]
        http.Get(url: "\(APIConstants.Favorits)", Tag: 2, headers: headers)
    }

}

extension FavaVC: HttpHelperDelegate {
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
                    
                   // print(json["days"].arrayValue)
                   // var str:[String] = []
//                    if json["days"].array!.count > 0
//                    {
//                        for i in json["days"].array!{
//                            str.append(i.stringValue)
//                        }
//                    }
//                    print(str.joined(separator: ","))
                    
                    
                    let obj = NearPlayGroundModelClass(
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
                        member: json["member"].stringValue,
                        reservation_no: json["reservation_no"].stringValue,
                        duration: json["duration"].stringValue,
                        time: json["time"].stringValue,
                        date: json["date"].stringValue
                        
                    )
                    FavItem.append(obj)
                }
                TBL_FAV.reloadData()
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

extension FavaVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  FavItem.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAVOURITESCell", for: indexPath) as! FAVOURITESCell
        
        
        cell.lblCapacity.text = FavItem[indexPath.row]._capacity
        cell.lblAddress.text = FavItem[indexPath.row]._address
        cell.lblSalary.text = FavItem[indexPath.row]._price
        cell.lblGroundName.text = FavItem[indexPath.row]._name
        cell.imgGround.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(FavItem[indexPath.row]._image)")
        
        cell.FavItems = FavItem[indexPath.row]
       
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
