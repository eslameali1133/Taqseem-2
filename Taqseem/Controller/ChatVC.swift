//
//  ChatVC.swift
//  Taqseem
//
//  Created by apple on 2/17/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class ChatVC: UIViewController {

    var PlayerMsg = [HistoryMsgModelClass]()
    var GroupMsg = [HistoryMsgModelClass]()
    var AllMsg = [HistoryMsgModelClass]()
    var TblMsg = [HistoryMsgModelClass]()
    var http = HttpHelper()
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnPlayer: UIButton!
    @IBOutlet weak var btnTeam: UIButton!
    
    
    @IBAction func btnAll(_ sender: Any) {
        btnAll.setTitleColor(.white, for: .normal)
        btnTeam.setTitleColor(.darkGray, for: .normal)
        btnPlayer.setTitleColor(.darkGray, for: .normal)
        TblMsg = AllMsg
        TblTeam.reloadData()
    }
    @IBAction func btnPlayer(_ sender: Any) {
        
        btnAll.setTitleColor(.darkGray, for: .normal)
        btnTeam.setTitleColor(.darkGray, for: .normal)
        btnPlayer.setTitleColor(.white, for: .normal)
        TblMsg = PlayerMsg
        TblTeam.reloadData()
    }
    @IBAction func btnTeam(_ sender: Any) {
        
        btnAll.setTitleColor(.darkGray, for: .normal)
        btnTeam.setTitleColor(.white, for: .normal)
        btnPlayer.setTitleColor(.darkGray, for: .normal)
        TblMsg = GroupMsg
        TblTeam.reloadData()
    }
    
    @IBOutlet weak var TblTeam: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if GIsNotification == true {
//            GIsNotification = false
//
//            let SelectedPlay = User(
//                user_id : GnotificationMsg._type_id ,
//                from : GnotificationMsg._from
//            )
//
//            print(SelectedPlay.user_id)
//
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
//            let cont = storyBoard.instantiateViewController(withIdentifier: "ChatpageVC")as! ChatpageVC
//            print(SelectedPlay)
//            cont.SelectedPlayer = SelectedPlay
//            self.present(cont, animated: true, completion: nil)
//
//        }
//        else{
        btnAll.setTitleColor(.white, for: .normal)
        btnTeam.setTitleColor(.darkGray, for: .normal)
        btnPlayer.setTitleColor(.darkGray, for: .normal)
        TblTeam.dataSource = self
        TblTeam.delegate = self
        TblTeam.changeView()
        http.delegate = self
        GetMsgHistory()
//        }
              }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func GetMsgHistory(){
       
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print("\(token_type) \(AccessToken)")
        let headers = [
            
            "Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage() 
        ]
        
        http.Get(url: APIConstants.GetMsgHistory, parameters:[:], Tag: 1, headers: headers)
        
    }

}

extension ChatVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TblMsg.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CahtCell", for: indexPath) as! CahtCell
        cell.lbl_chatCounter.text = TblMsg[indexPath.row]._count
        cell.lblName.text = TblMsg[indexPath.row]._from_name
        cell.lblTime.text = TblMsg[indexPath.row]._time
        cell.imgLabel.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(TblMsg[indexPath.row]._from_photo)" )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var SelectedPlay : User!
        if TblMsg[indexPath.row]._type == "player"{
            let userId = AppCommon.sharedInstance.getJSON("Profiledata")["id"].stringValue
            if TblMsg[indexPath.row]._from_id == userId{
                SelectedPlay = User(
                    user_id:TblMsg[indexPath.row]._to_id ,
                    from: TblMsg[indexPath.row]._to_name
                )
            }else{
                SelectedPlay = User(
                    user_id:TblMsg[indexPath.row]._from_id ,
                    from: TblMsg[indexPath.row]._from_name
                )
            }
            
            print(SelectedPlay.user_id)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
            let cont = storyBoard.instantiateViewController(withIdentifier: "ChatpageVC")as! ChatpageVC
            print(SelectedPlay)
            cont.SelectedPlayer = SelectedPlay
            self.present(cont, animated: true, completion: nil)
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
            let cont = storyBoard.instantiateViewController(withIdentifier: "ChatRoomVC")as! ChatRoomVC
            cont.GroupID = TblMsg[indexPath.row]._to_id
            self.present(cont, animated: true, completion: nil)
        }
        print(123)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
extension ChatVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        if Tag == 1 {
            
            let status = json["status"]
            let data =  json["data"]
            print(data)
            if status.stringValue == "1" {
                
                let PlayerData = data["player"]
                let GroupData = data["group"]
                let AllData = data["all"]
                print(PlayerData)
                print(GroupData)
                print(AllData)
                for json in PlayerData.array! {
                    print(json)
                    var time = json["time"]
                    var datee = time["date"].stringValue
                    let message = HistoryMsgModelClass(
                        from_name: json["from_name"].stringValue,
                        from_id: json["from_id"].stringValue,
                        from_photo: json["from_photo"].stringValue,
                        to_name: json["to_name"].stringValue,
                        to_id: json["to_id"].stringValue,
                        to_photo: json["to_photo"].stringValue,
                        count: json["count"].stringValue,
                        time: datee,
                        type: json["type"].stringValue

                    )
                    print(message)
                    self.PlayerMsg.append(message)
                    //                        }

                }
                print(PlayerMsg.count)
                for json in GroupData.array! {
                    print(json)
                    var time = json["time"]
                    var datee = time["date"].stringValue
                    let message = HistoryMsgModelClass(
                        from_name: json["from_name"].stringValue,
                        from_id: json["from_id"].stringValue,
                        from_photo: json["from_photo"].stringValue,
                        to_name: json["to_name"].stringValue,
                        to_id: json["to_id"].stringValue,
                        to_photo: json["to_photo"].stringValue,
                        count: json["count"].stringValue,
                        time: datee,
                        type: json["type"].stringValue

                    )
                    print(message)
                    self.GroupMsg.append(message)
                    //                        }

                }
                print(GroupMsg.count)
                for json in AllData.array! {
                    print(json)
                    var time = json["time"]
                    var datee = time["date"].stringValue
                    let message = HistoryMsgModelClass(
                        from_name: json["from_name"].stringValue,
                        from_id: json["from_id"].stringValue,
                        from_photo: json["from_photo"].stringValue,
                        to_name: json["to_name"].stringValue,
                        to_id: json["to_id"].stringValue,
                        to_photo: json["to_photo"].stringValue,
                        count: json["count"].stringValue,
                        time: datee ,
                        type: json["type"].stringValue
                    )
                    print(message)
                    self.AllMsg.append(message)
                    //                        }

                }
                print(AllMsg.count)
                TblMsg = AllMsg
                TblTeam.reloadData()
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


