//
//  NotificationVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 4/26/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotificationVC: UIViewController {

    @IBOutlet weak var tblNotifications: UITableView!
    var notifications = [NotificationModelClass]()
    var http = HttpHelper()
    override func viewDidLoad() {
        super.viewDidLoad()

        tblNotifications.dataSource = self
        tblNotifications.delegate = self
        http.delegate = self
        GetNotification()
        // Do any additional setup after loading the view.
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func GetNotification(){
        
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print("\(token_type) \(AccessToken)")
        let headers = [
            
            "Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage()
        ]
        
        http.Get(url: APIConstants.GetNotification, parameters:[:], Tag: 1, headers: headers)
        
    }
}
extension NotificationVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.lblTime.text = notifications[indexPath.row]._created_at
        cell.lblTitle.text = notifications[indexPath.row]._from
        cell.lblMessage.text = notifications[indexPath.row]._msg
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(123)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
extension NotificationVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        if Tag == 1 {
            
            let status = json["status"]
            let Ndata = json["data"]
            let data =  Ndata["data"]
            print(data)
            if status.stringValue == "1" {
                
                for json in data.array! {
                    print(json)
                    let message = NotificationModelClass(
                        msg: json["msg"].stringValue,
                        type: json["type"].stringValue,
                        type_id: json["type_id"].stringValue,
                        from: json["from"].stringValue,
                        seen: json["seen"].stringValue,
                        created_at : json["created_at"].stringValue
                        
                    )
                    print(message)
                    self.notifications.append(message)
                    //                        }
                    
                }
                               tblNotifications.reloadData()
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
