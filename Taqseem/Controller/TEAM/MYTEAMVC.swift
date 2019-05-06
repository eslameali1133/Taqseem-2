//
//  MYTEAMVC.swift
//  Taqseem
//
//  Created by apple on 2/28/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class MYTEAMVC: UIViewController {

    var isTeam = false
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var btn_mem: UIButton!
    @IBOutlet weak var btn_chat: UIButton!
       @IBOutlet weak var btn_information: UIButton!
    @IBOutlet weak var btn_NextMAtch: UIButton!
    
    
    @IBOutlet weak var member: UIView!
    @IBOutlet weak var chat: UIView!
      @IBOutlet weak var Nextmatch: UIView!
    @IBOutlet weak var Information: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        member.isHidden = false
        chat.isHidden = true
        Nextmatch.isHidden = true
        Information.isHidden = true
        
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btn_nextmatch(_ sender: Any) {
         Nextmatch.isHidden = false
        chat.isHidden = true
        member.isHidden = true
         Information.isHidden = true
        btn_NextMAtch.setTitleColor(.white, for: .normal)
                btn_mem.setTitleColor(.darkGray, for: .normal)
          btn_information.setTitleColor(.darkGray, for: .normal)
        
        
    }

    @IBAction func btnChat(_ sender: Any) {
        Nextmatch.isHidden = true
        chat.isHidden = false
        member.isHidden = true
        Information.isHidden = true
        btn_NextMAtch.setTitleColor(.darkGray, for: .normal)
        btn_mem.setTitleColor(.darkGray, for: .normal)
        btn_information.setTitleColor(.darkGray, for: .normal)
    }
    @IBAction func btnMember(_ sender: Any) {
        Nextmatch.isHidden = true
        chat.isHidden = true
        member.isHidden = false
        Information.isHidden = true
        btn_NextMAtch.setTitleColor(.darkGray, for: .normal)
        btn_mem.setTitleColor(.white, for: .normal)
        btn_information.setTitleColor(.darkGray, for: .normal)
        
    }
    
    
    @IBAction func btnInformation(_ sender: Any) {
        Nextmatch.isHidden = true
        chat.isHidden = true
        member.isHidden = true
        Information.isHidden = false
        btn_NextMAtch.setTitleColor(.darkGray, for: .normal)
         btn_mem.setTitleColor(.darkGray, for: .normal)
        btn_information.setTitleColor(.white, for: .normal)
        
    }
    
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

   

}
