//
//  PlayerTableVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 2/20/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class PlayerTableVC: UIViewController {

    var http = HttpHelper()
    var items = [RequestPlayerModelClass]()
    @IBOutlet weak var tblPlayer: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self
        tblPlayer.dataSource = self
        tblPlayer.delegate = self
        tblPlayer.changeView()

        fillData()
        // Do any additional setup after loading the view.
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fillData()  {
        print(GMatchDetails._Time)
        print(GMatchDetails._Date)
        items.removeAll()
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        let params = [
            "date":GMatchDetails._Date,
            "time":GMatchDetails._PTime,
            "ground_id":Gitem._id
            ] as [String: Any]
        
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
        ]
        
        
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.PlayersMatch, method: .post, parameters: params, tag: 1, header: headers)
    }
    
}
extension PlayerTableVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        
        if Tag == 1 {
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
                    let obj = RequestPlayerModelClass(
                        id: json["id"].stringValue,
                        name: json["name"].stringValue,
                        photo: json["photo"].stringValue,
                        position: json["position"].stringValue,
                        position1: json["position1"].stringValue
                        
                    )
                    if GCurrentPlayer.user_id != json["id"].stringValue{
                        items.append(obj)
                        
                    }
                }
                tblPlayer.reloadData()
                AppCommon.sharedInstance.dismissLoader(self.view)
                
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
    extension PlayerTableVC :UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(items.count)
            return  items.count
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
            print(items[indexPath.row]._name)
            cell.lblPlayerName.text = items[indexPath.row]._name
            cell.PlayerID = items[indexPath.row]._id
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 95
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        private func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 5
        }
        
        private func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return UIView.init(frame: CGRect.zero)
        }
        private func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 5
        }
        
        private func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView.init(frame: CGRect.zero)
        }
         
}
