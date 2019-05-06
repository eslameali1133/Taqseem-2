//
//  INFROTEAMVC.swift
//  Taqseem
//
//  Created by apple on 2/28/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class INFROTEAMVC: AllignLocalizerVC {

    @IBOutlet weak var imgLogo: customImageView!{
        didSet{
            imgLogo.layer.cornerRadius =  imgLogo.frame.width / 2
            imgLogo.layer.borderWidth = 1
            imgLogo.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    override func viewDidLoad() {
         self.reloadInputViews()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SetData()
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let sb = UIStoryboard(name: "TEAM", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: "TeaminfoVC") as! TeaminfoVC
        controller.comeFromeRegister = false
        self.show(controller, sender: true)
    }
    
    @IBAction func btnDelet(_ sender: Any) {
    }
    
    func  SetData(){
        
        lblCapacity.text = AppCommon.sharedInstance.getJSON("Teamdata")["capacity"].stringValue
        lblName.text = AppCommon.sharedInstance.getJSON("Teamdata")["name"].stringValue
        print(AppCommon.sharedInstance.getJSON("Teamdata")["logo"].stringValue)
        imgLogo.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(AppCommon.sharedInstance.getJSON("Teamdata")["logo"].stringValue)")
    }

}
