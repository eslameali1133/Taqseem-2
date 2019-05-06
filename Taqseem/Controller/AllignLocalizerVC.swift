//
//  AllignLocalizerVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 5/5/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class AllignLocalizerVC: AllignText_LabelVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        // Do any additional setup after loading the view.
    }
    

}
