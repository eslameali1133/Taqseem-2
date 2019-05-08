//
//  PlayerNormalVC.swift
//  Taqseem
//
//  Created by apple on 2/25/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class PlayerNormalVC: UIViewController {

    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var tblPlayer: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblPlayer.dataSource = self
        tblPlayer.delegate = self
        tblPlayer.changeView()
        
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
extension PlayerNormalVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  10
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchVC")as! MyMatchVC
        self.present(cont, animated: true, completion: nil)
        print(123)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
}

