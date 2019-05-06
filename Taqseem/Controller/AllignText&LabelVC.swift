//
//  AllignText&LabelVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 5/5/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit

class AllignText_LabelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
extension AllignText_LabelVC {
    
    //Align Textfield Text
    
    func loopThroughSubViewAndAlignTextfieldText(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UITextField && subView.tag <= 0{
                    let textField = subView as! UITextField
                    textField.textAlignment = Language.isArabicLanguage ? .right: .left
                } else if subView is UITextView && subView.tag <= 0{
                    let textView = subView as! UITextView
                    textView.textAlignment = Language.isArabicLanguage ? .right: .left
                    
                }
                
                loopThroughSubViewAndAlignTextfieldText(subviews: subView.subviews)
            }
        }
    }
    
    
    //Align Label Text
    func loopThroughSubViewAndAlignLabelText(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UILabel && subView.tag <= 0 {
                    let label = subView as! UILabel
                    label.textAlignment = Language.isArabicLanguage ? .right : .left
                }
                loopThroughSubViewAndAlignLabelText(subviews: subView.subviews)
            }
        }
    }
}


class Language {
    
    static var isArabicLanguage : Bool {
        get {
            return SharedData.SharedInstans.getLanguage() == "ar"
        }
    }
}

