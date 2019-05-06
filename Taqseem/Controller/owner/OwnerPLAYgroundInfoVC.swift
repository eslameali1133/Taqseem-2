//
//  OwnerPLAYgroundInfoVC.swift
//  Taqseem
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class OwnerPLAYgroundInfoVC: AllignLocalizerVC {
    var items = GlobalGroundDetails
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTimes: UILabel!
    @IBOutlet weak var lblDayes: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblMatchPlayed: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGroundName: UILabel!
    @IBOutlet weak var imgGround: customImageView!{
        didSet{
            imgGround.layer.cornerRadius =  imgGround.frame.width / 2
            imgGround.layer.borderWidth = 1
            //            ProfileImageView.layer.borderColor =  UIColor(red: 0, green: 156, blue: 158, alpha: 1) as! CGColor
            
            imgGround.clipsToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        FillData()
    }
    
    
    @IBAction func btn_Edit(_ sender: Any) {
      
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "AddPlayGroundVC")as! AddPlayGroundVC
isEidtplayground = true
        cont.Title = AppCommon.sharedInstance.localization("Edit Playground")
        self.show(cont, sender: true)
        
    }
    
    func FillData(){

        lblDayes.text = items?._days
        lblPrice.text = items?._price
        lblTimes.text = "From : \(items!._hour_from)   To : \(items!._hour_to)"
        lblCapacity.text = items?._capacity
        lblLocation.text = items?._address
        lblGroundName.text = items?._name
        lblMatchPlayed.text = items?._matches //////
        imgGround.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\((items?._image)!)")
    }
    

}
