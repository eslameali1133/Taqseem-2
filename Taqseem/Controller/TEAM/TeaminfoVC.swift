//
//  TeaminfoVC.swift
//  Taqseem
//
//  Created by apple on 2/28/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos
import SwiftyJSON
class TeaminfoVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource , UIImagePickerControllerDelegate ,UINavigationControllerDelegate  {
 var PickerFlag = " "
    var comeFromeRegister = true
    var teamOperation = ""
    var AlertController: UIAlertController!
    let http = HttpHelper()
    let imgpicker = UIImagePickerController()
    
    @IBOutlet weak var imgLogo: customImageView!{
        didSet{
            imgLogo.layer.cornerRadius =  imgLogo.frame.width / 2
            imgLogo.layer.borderWidth = 1
            //            ProfileImageView.layer.borderColor =  UIColor(red: 0, green: 156, blue: 158, alpha: 1) as! CGColor
            
            imgLogo.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var txtTeamName: UITextField!
    @IBOutlet weak var lblCapacity: UILabel!
     var TeamCapacity = [0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , 14 ]   //was from 5 to 8
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if comeFromeRegister == false {
        SetData()
        }
        SetupUploadImage()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validation(){
            AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
            UpdateProfile()
        }
    }
    @IBAction func btnChangeImage(_ sender: Any) {
        imgpicker.delegate = self
        imgpicker.allowsEditing = false
        self.present(AlertController, animated: true, completion: nil)
    }
    @IBAction func btnCapacity(_ sender: Any) {
        PickerFlag = "Capacity"
        configurePicker()
    }

    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func  SetData(){
        
        lblCapacity.text = AppCommon.sharedInstance.getJSON("Teamdata")["capacity"].stringValue
        txtTeamName.text = AppCommon.sharedInstance.getJSON("Teamdata")["name"].stringValue
        imgLogo.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(AppCommon.sharedInstance.getJSON("Teamdata")["logo"].stringValue)")
    }
    
    
    func SetupUploadImage()
    {
        AlertController = UIAlertController(title:"" , message:AppCommon.sharedInstance.localization("ChoseImage") , preferredStyle: UIAlertController.Style.actionSheet)
        
        let Cam = UIAlertAction(title: AppCommon.sharedInstance.localization("camera"), style: UIAlertAction.Style.default, handler: { (action) in
            self.openCame()
        })
        let Gerall = UIAlertAction(title: AppCommon.sharedInstance.localization("gallery"), style: UIAlertAction.Style.default, handler: { (action) in
            self.opengelar()
        })
        
        let Cancel = UIAlertAction(title: AppCommon.sharedInstance.localization("cancel"), style: UIAlertAction.Style.cancel, handler: { (action) in
            //
        })
        
        self.AlertController.addAction(Cam)
        self.AlertController.addAction(Gerall)
        self.AlertController.addAction(Cancel)
    }
    
    func openCame(){
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func opengelar(){
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ imgpicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imgLogo.image = selectedImage
        
        imgpicker.dismiss(animated: true, completion: nil)
    }
    
    func validation () -> Bool {
        var isValid = true
        
        
        
        
        if txtTeamName.text! == "" {
            Loader.showError(message: AppCommon.sharedInstance.localization("Team Name field cannot be left blank"))
            isValid = false
        }
        
        return isValid
    }
    
    
    func UpdateProfile() {
        if comeFromeRegister == true {
            teamOperation = "add-team"
        }else{
            teamOperation = "update-team"
        }
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        var parameters = [:] as [String: Any]
        
        print(AccessToken)
        let imgdata = self.imgLogo.image!.jpegData(compressionQuality: 0.5)
        print(AccessToken)
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-type": "multipart/form-data",
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
            
        ]
        
        parameters = [
            "name" : txtTeamName.text!,
            "logo" : imgdata!,
            "capacity" : lblCapacity.text!
        ]
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameters {
                    if let value = value as? String {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
                if let data = self.imgLogo.image!.jpegData(compressionQuality: 0.5){
                    multipartFormData.append(data, withName: "logo", fileName: "logo\(arc4random_uniform(100))"+".jpeg", mimeType: "jpeg")
                    
                }
                
        },
            usingThreshold:UInt64.init(),
            to: "http://172.107.175.8/api/\(teamOperation)",
            method: .post, headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print(progress)
                    })
                    upload.responseJSON { response in
                        // If the request to get activities is succesfull, store them
                        if response.result.isSuccess{
                            print(response.debugDescription)
                            AppCommon.sharedInstance.dismissLoader(self.view)
                            print(response.data!)
                            print(response.result)
                            let json = JSON(response.data)
                            print(json)
                            let status =  json["status"]
                            print(status.stringValue)
                            let message = json["message"]
                            let data =  JSON(json["data"])
                            print(data)
                            
                            if status.stringValue == "1" {
                                
                                AppCommon.sharedInstance.saveJSON(json: data, key: "Teamdata")
                                print(AppCommon.sharedInstance.getJSON("Teamdata")["name"].stringValue)
                                if self.comeFromeRegister == true {
                                
                                 Loader.showSuccess(message: "Team added Successfuly")
                                    
                                    let delegate = UIApplication.shared.delegate as! AppDelegate
                                    //  let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                                    let storyboard = UIStoryboard.init(name: "Player", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                                    
                                }else {
//                                    
//                                    let sb = UIStoryboard(name: "TEAM", bundle: nil)
//                                    let controller = sb.instantiateViewController(withIdentifier: "INFROTEAMVC") as! INFROTEAMVC
//                                    self.show(controller, sender: true)
                                    Loader.showSuccess(message: "Team information updated Successfuly")
                                self.dismiss(animated: true, completion: nil)
                                }

                            }else{
                                Loader.showError(message: message.stringValue)
                            }
                            
                        } else {
                            var errorMessage = "ERROR MESSAGE: "
                            if let data = response.data {
                                // Print message
                                print(errorMessage)
                                AppCommon.sharedInstance.dismissLoader(self.view)
                                
                                
                                
                            }
                            print(errorMessage) //Contains General error message or specific.
                            print(response.debugDescription)
                            AppCommon.sharedInstance.dismissLoader(self.view)
                        }
                        
                        
                    }
                case .failure(let encodingError):
                    print("FALLE ------------")
                    print(encodingError)
                    AppCommon.sharedInstance.dismissLoader(self.view)
                }
        }
        )
    }
    
    func configurePicker (){
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 255)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if PickerFlag == "Capacity"{
            return TeamCapacity.count
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//         if PickerFlag == "Capacity" {
            if row == 0{
                return "Select The Team Capacity "
            }
            return String(TeamCapacity[row])
//        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if PickerFlag == "Duration" {
//            lblDuration.text = String(Duration[row])
        }else if PickerFlag == "Capacity" {
            lblCapacity.text = String(TeamCapacity[row])
        } else {
//            lblFees.text = String(Fees[row])
        }
    }
    
}
