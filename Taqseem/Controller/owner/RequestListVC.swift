//
//  RequestListVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 3/6/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class RequestListVC: UIViewController {
    var RequestStatus = ""
    var http = HttpHelper()
    var items = [RequestListModelClass]()
    var itemSelectedid:[Int] = []
    
    @IBOutlet weak var tblRequestDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        http.delegate = self
        tblRequestDetails.delegate = self
        tblRequestDetails.dataSource = self
        // Do any additional setup after loading the view.
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillData()
        tblRequestDetails.reloadData()
    }
    
    func fillData()  {
        items.removeAll()
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print(token_type , AccessToken)
        print(AccessToken)
        let headers: HTTPHeaders = ["Authorization" : "\(token_type) \(AccessToken)",
               "lang":SharedData.SharedInstans.getLanguage() 
        ]
        http.Get(url: "\(APIConstants.GetRequest)", Tag: 2, headers: headers)
    }
    
}


extension RequestListVC: HttpHelperDelegate {
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
                    let obj = RequestListModelClass(
                        ground_id: json["ground_id"].stringValue,
                        ground_image: json["ground_image"].stringValue,
                        ground_name: json["ground_name"].stringValue,
                        user_name: json["user_name"].stringValue,
                        capacity: json["capacity"].stringValue,
                        reservation_no: json["reservation_no"].stringValue,
                        duration: json["duration"].stringValue,
                        date: json["date"].stringValue,
                        time: json["time"].stringValue,
                        reservation_type: json["reservation_type"].stringValue,
                        reservation_status: json["reservation_status"].stringValue,
                        photo: json["photo"].stringValue
                    
                 )
                        items.append(obj)
                }
                tblRequestDetails.reloadData()
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



    extension RequestListVC :UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailCell", for: indexPath) as! RequestDetailCell
            cell.cntntView.dropShadow()
            cell.lblCapacity.text = items[indexPath.row]._capacity
            cell.lblDate.text = items[indexPath.row]._date
            cell.lblTime.text = items[indexPath.row]._time
           
            cell.lblGroundName.text = items[indexPath.row]._ground_name
            cell.lblPlayerName.text = items[indexPath.row]._user_name
            cell.imgGround.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(items[indexPath.row]._ground_image)")
            cell.imgUser.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(items[indexPath.row]._photo)")
            if items[indexPath.row]._reservation_status == "ACCEPTED"
            {
                //cell.btnStatus.backgroundColor = UIColor(hex: "#259FA1")
                cell.btnStatus.setTitle(AppCommon.sharedInstance.localization("ACCEPTED"), for : .normal)
                cell.btnStatus.backgroundColor = UIColor.hexColor(string: "#259FA1")
            } else if items[indexPath.row]._reservation_status == "REJECTED" {
                cell.btnStatus.setTitle(AppCommon.sharedInstance.localization("NEW"), for : .normal)
                cell.btnStatus.backgroundColor = UIColor.red
            }else {
                cell.btnStatus.setTitle(AppCommon.sharedInstance.localization("NEW"), for : .normal)
                cell.btnStatus.backgroundColor = UIColor.hexColor(string:"#F9C216")
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
            let cont = storyBoard.instantiateViewController(withIdentifier: "RequestDetailsVC")as! RequestDetailsVC
            
            cont.items = items[indexPath.row]
            self.present(cont, animated: true, completion: nil)
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 170
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
}
