//
//  AddNewVisaVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 2/22/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class AddNewVisaVC: UIViewController {
    
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var txtCardName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.dismiss(animated: true, completion: nil)
    }

}
