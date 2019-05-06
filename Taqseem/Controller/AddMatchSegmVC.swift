//
//  AddMatchSegmVC.swift
//  Taqseem
//
//  Created by apple on 2/24/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class AddMatchSegmVC: UIViewController {

    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var btn_mem: UIButton!
        @IBOutlet weak var btn_chat: UIButton!
        @IBOutlet weak var btn_playground: UIButton!

    
    @IBOutlet weak var member: UIView!
    @IBOutlet weak var chat: UIView!
    @IBOutlet weak var Playground: UIView!
    
    @IBAction func btnPlayGround(_ sender: Any) {
        chat.isHidden = true
        Playground.isHidden = false
        member.isHidden = true
        btn_playground.setTitleColor(.white, for: .normal)
        btn_chat.setTitleColor(.darkGray, for: .normal)
        btn_mem.setTitleColor(.darkGray, for: .normal)
       
        
    }
    @IBAction func btnChat(_ sender: Any) {
        member.isHidden = true
        Playground.isHidden = true
        chat.isHidden = false
        
        btn_chat.setTitleColor(.white, for: .normal)
        btn_playground.setTitleColor(.darkGray, for: .normal)
        btn_mem.setTitleColor(.darkGray, for: .normal)
        
    }
    @IBAction func btnMember(_ sender: Any) {
        member.isHidden = false
        chat.isHidden = true
        Playground.isHidden = true
        
        btn_mem.setTitleColor(.white, for: .normal)
        btn_chat.setTitleColor(.darkGray, for: .normal)
        btn_playground.setTitleColor(.darkGray, for: .normal)
        
    }
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        member.isHidden = false
        chat.isHidden = true
        Playground.isHidden = true
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
    }
    

    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Confirm(_ sender: Any) {
      
        let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "PaidVC")as! PaidVC
        self.present(cont, animated: true, completion: nil)
        
        
//    let delegate = UIApplication.shared.delegate as! AppDelegate
//    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let storyboard = UIStoryboard.init(name: "Player", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
//    }
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
    }
    
}
