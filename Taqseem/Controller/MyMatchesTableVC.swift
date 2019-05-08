//
//  MyMatchesTableVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 2/20/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class MyMatchesTableVC: UIViewController {

    var http = HttpHelper()
    var Matchs = [MatchsModelClass]()
    
     let cellSpacingHeight: CGFloat = 10
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var tblMyMatch: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self
        tblMyMatch.dataSource = self
        tblMyMatch.delegate = self
        tblMyMatch.changeView()

        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DismissView(_ sender: Any) {
        if GisAcceptNotification == true {
            GisAcceptNotification = false
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard.init(name: "Player", bundle: nil);
            delegate.window?.rootViewController =
        storyboard.instantiateInitialViewController()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillData()
    }
    
    func fillData()  {
        Matchs.removeAll()
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print(token_type , AccessToken)
        print(AccessToken)
        let headers: HTTPHeaders = ["Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage() ]
        http.Get(url: "\(APIConstants.MyMatchs)", Tag: 2, headers: headers)
    }
    
    

}

extension MyMatchesTableVC: HttpHelperDelegate {
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
                    let obj = MatchsModelClass(
                        ground_id: json["ground_id"].stringValue,
                        note: json["ground_image"].stringValue,
                        ground_image: json["note"].stringValue,
                        ground_name: json["ground_name"].stringValue,
                        price: json["price"].stringValue,
                        address: json["address"].stringValue,
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
                    Matchs.append(obj)
                }
                tblMyMatch.reloadData()
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


    extension MyMatchesTableVC :UITableViewDelegate,UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 10
        }
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            return view
        }
        
        
        // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cellSpacingHeight
        }
        
        // Make the background color show through
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  Matchs.count
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchCell", for: indexPath) as! MyMatchCell
            cell.viewcontent.dropShadow()
            cell.lblDate.text = Matchs[indexPath.row]._date
            cell.lblGroundName.text = Matchs[indexPath.row]._ground_name
            cell.lblTime.text = Matchs[indexPath.row]._time
            cell.lblUName.text = Matchs[indexPath.row]._user_name
            print(Matchs[indexPath.row]._photo)
            if Matchs[indexPath.row]._photo != "" {
            cell.imgUser.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(Matchs[indexPath.row]._photo)")
            }
            
            print(Matchs[indexPath.row]._ground_image)
            if Matchs[indexPath.row]._ground_image != "" {
            cell.imgGround.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(Matchs[indexPath.row]._ground_image)")
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchVC")as! MyMatchVC
                comedromneartoplay = "MyMatch"
                cont.match = Matchs[indexPath.row]
                cont.comeFrom = "MyMatches"
                self.present(cont, animated: true, completion: nil)
                print(123)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 165
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
      
        
       
    }

