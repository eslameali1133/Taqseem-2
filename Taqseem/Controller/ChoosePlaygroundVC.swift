//
//  ChoosePlaygroundVC.swift
//  Taqseem
//
//  Created by apple on 2/24/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class ChoosePlaygroundVC: UIViewController {

    var items = [PlaygroundModelClass]()
    var NearItems = [NearPlayGroundModelClass]()
    var MatchDetais : MatchDetailsModelClass!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var TBL_Background: UITableView!
    
     @IBOutlet weak var lbl_title: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(items)
        if comedromneartoplay == "NearME"
        {
            lbl_title.text = "NEAR ME"
        }
        TBL_Background.dataSource = self
        TBL_Background.delegate = self
        TBL_Background.changeView()
        
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        // Do any additional setup after loading the view.
    }
   
//    @IBAction func btn_choose(_ sender: UIButton) {
//        if comedromneartoplay == true
//        {
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
//            let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchVC")as! MyMatchVC
//            cont.item = items[indexPath.row]
//            self.present(cont, animated: true, completion: nil)
//
//        }else{
//
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
//            let cont = storyBoard.instantiateViewController(withIdentifier: "playGroundDetailsVC")as! playGroundDetailsVC
//            self.present(cont, animated: true, completion: nil)
//
//        }
//    }
    
    

}
extension ChoosePlaygroundVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comedromneartoplay == "NearME" {
            
            return  NearItems.count
        }else{
        
        return  items.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosebackgroundCell", for: indexPath) as! ChoosebackgroundCell
        cell.contentView.dropShadow()
        if comedromneartoplay == "NearME" {
            cell.lblCapacity.text = "\(NearItems[indexPath.row]._capacity) Players"
            cell.lblName.text = NearItems[indexPath.row]._name
            cell.lblPrice.text = "\(NearItems[indexPath.row]._price) SAL/h"
            //        cell.lblLocation.text = ""
            cell.imgGround.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(NearItems[indexPath.row]._image)")
            cell.NearItems = NearItems[indexPath.row]
           // cell.MatchDetails = MatchDetais
            
        }else {
        cell.lblCapacity.text = "\(items[indexPath.row]._capacity) Players"
        cell.lblName.text = items[indexPath.row]._name
        cell.lblPrice.text = "\(items[indexPath.row]._price) SAL/h"
//        cell.lblLocation.text = ""
        cell.imgGround.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(items[indexPath.row]._image)")
            if items[indexPath.row]._favorite == "0"{
                cell.imgStar.image = UIImage(named: "star-1")
            }else{
                cell.imgStar.image = UIImage(named: "star-2")
            }
        cell.items = items[indexPath.row]
        cell.MatchDetails = MatchDetais
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print(123)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
