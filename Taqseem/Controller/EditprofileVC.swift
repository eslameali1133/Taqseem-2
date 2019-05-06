//
//  EditprofileVC.swift
//  Taqseem
//
//  Created by apple on 2/17/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos
import SwiftyJSON
class EditprofileVC: UIViewController , UIImagePickerControllerDelegate ,UINavigationControllerDelegate , UIPickerViewDelegate , UIPickerViewDataSource {
    var Position = ["FD مهاجم" , "MD لاعب وسط" , "DF مدافع" , "GK  حارس مرمي"]
    var pickerview  = UIPickerView()

    var toolBar = UIToolbar()
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var imgProfile:customImageView!{
        didSet{
            imgProfile.layer.cornerRadius =  imgProfile.frame.width / 2
            imgProfile.layer.borderWidth = 1
            //            ProfileImageView.layer.borderColor =  UIColor(red: 0, green: 156, blue: 158, alpha: 1) as! CGColor
            
            imgProfile.clipsToBounds = true
            
        }
    }
    
    var AlertController: UIAlertController!
    let http = HttpHelper()
    let picker = UIImagePickerController()
    @IBOutlet weak var pickerPosition: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
      imgProfile.dropShadow()
       // http.delegate = self
        SetData()
        SetupUploadImage()
        picker.delegate = self
       
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        
    }
    
    @IBAction func btnPosition(_ sender: Any) {
        onDoneButtonTapped()
        configurePicker()
        
    }
    @IBAction func btnSaveChanges(_ sender: Any) {
        if validation(){
            AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
            UpdateProfile()
        }
    }
    @IBAction func btnChangeImage(_ sender: Any) {
        picker.delegate = self
        picker.allowsEditing = false
        self.present(AlertController, animated: true, completion: nil)
    }
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func configurePicker (){
        pickerview = UIPickerView.init()
        pickerview.delegate = self
        pickerview.backgroundColor = UIColor.white
        pickerview.setValue(UIColor.black, forKey: "textColor")
        pickerview.autoresizingMask = .flexibleWidth
        pickerview.contentMode = .center
        pickerview.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 255)
        self.view.addSubview(pickerview)
        
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(onDoneButtonTapped))]
        
        
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        pickerview.removeFromSuperview()
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return Position.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(Position[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            lblPosition.text = "FD"
        }else if row == 1{
            lblPosition.text = "MD"
        }else if row == 2{
    lblPosition.text = "DF"
        }else if row == 3{
    lblPosition.text = "GK"
    }
        
}
    
    func  SetData(){
        txtUserName.text = AppCommon.sharedInstance.getJSON("Profiledata")["name"].stringValue
        txtEmail.text = AppCommon.sharedInstance.getJSON("Profiledata")["email"].stringValue
        txtPhoneNumber.text = AppCommon.sharedInstance.getJSON("Profiledata")["phone"].stringValue
        
        lblPosition.text = AppCommon.sharedInstance.getJSON("Profiledata")["position"].stringValue
        print("\(APIConstants.Base_Image_URL)\(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)")
        
        imgProfile.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)")
        
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
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imgProfile.image = selectedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func validation () -> Bool {
        var isValid = true
        
        
        
        if (txtPhoneNumber.text?.count)! != 11  {
            Loader.showError(message: AppCommon.sharedInstance.localization("Phone number must be between 7 and 17 characters long"))
            isValid = false
        }
        
        if txtPhoneNumber.text! == "" {
            Loader.showError(message: AppCommon.sharedInstance.localization("Phone field cannot be left blank"))
            isValid = false
        }
        if txtUserName.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Name field cannot be left blank"))
            isValid = false
        }
        if lblPosition.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Position field cannot be left blank"))
            isValid = false
        }
        
        if txtEmail.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Email field cannot be left blank"))
            isValid = false
        }
        
        
        return isValid
    }
    
    
    func UpdateProfile() {
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
         let token_type = UserDefaults.standard.string(forKey: "token_type")!
        var parameters = [:] as [String: Any]
        
        print(AccessToken)
        let imgdata = self.imgProfile.image!.jpegData(compressionQuality: 0.5)
        print(imgdata!)
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-type": "multipart/form-data",
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
            
        ]
        parameters = [
            "name" : txtUserName.text!,
            "phone": txtPhoneNumber.text!,
            "email": txtEmail.text!,
            "photo" : imgdata!,
            "position": lblPosition.text!,
            
        ]
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameters {
                    if let value = value as? String {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
//                if let data = self.imgProfile.image!.jpegData(compressionQuality: 0.5){
//                    multipartFormData.append(data, withName: "image", fileName: "Venderphoto\(arc4random_uniform(100))"+".jpeg", mimeType: "image/jpeg")
                if let data = self.imgProfile.image!.jpegData(compressionQuality: 0.5){
                    multipartFormData.append(data, withName: "photo", fileName: "photo\(arc4random_uniform(100))"+".jpeg", mimeType: "jpeg")
                
                
                }
                
                //                let data = self.imageProfile.image!.jpegData(compressionQuality: 0.5)
                //
                //                multipartFormData.append(data!, withName: "Venderphoto", fileName: "Venderphoto\(arc4random_uniform(100))"+".jpeg", mimeType: "image/jpeg")
                
        },
            usingThreshold:UInt64.init(),
            to: "http://172.107.175.8/api/edit-profile",
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
                        
                                AppCommon.sharedInstance.saveJSON(json: data, key: "Profiledata")
                                print(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)
                                Loader.showSuccess(message: "Profile Data Updated Successfuly")
                                
                                self.dismiss(animated: true, completion: nil)
//                                let sb = UIStoryboard(name: "Player", bundle: nil)
//                                let controller = sb.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
//                                    self.show(controller, sender: true)
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
    

}
