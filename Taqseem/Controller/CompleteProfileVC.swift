//
//  CompleteProfileVC.swift
//  Taqseem
//
//  Created by apple on 2/7/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class CompleteProfileVC: UIViewController {

    @IBOutlet weak var btnArrow: UIButton!
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
