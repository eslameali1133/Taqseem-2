//
//  AddPlayGroundVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 3/5/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
 var isEidtplayground = false
protocol shareLocationDelegate {
    func shareLocationDelegate(lat: String, Long: String)
}
class AddPlayGroundVC: AllignLocalizerVC  , UIPickerViewDelegate , UIPickerViewDataSource{
     var items = GlobalGroundDetails
  var  daysname = ["sat","sun","mon","tue","wed","thu","fri"]
    var CityArray: [CityModelClass] = [CityModelClass]()
    var AreaArray: [AreaModelClass] = [AreaModelClass]()
    var days:[DayModel] = [DayModel]()
    var groundid = ""
    var CityID = ""
    var AreaID = ""
    var isEidt = false
    var Title = AppCommon.sharedInstance.localization("Add Playground")
      var PickerFlag = ""
    var AlertController: UIAlertController!
    let Imagepicker = UIImagePickerController()
    var dateis = " "
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var datePicker = UIDatePicker()
    var TeamCapacity = [0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , 14]
    @IBOutlet weak var lblCapacity: UILabel!
      @IBOutlet weak var lblCity: UILabel!
      @IBOutlet weak var lblAream: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
   
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var txtFees: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtHours: UITextField!
    @IBOutlet weak var txtPhoneNum: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtEnglishName: UITextField!
    @IBOutlet weak var txtArabicName: UITextField!
    @IBOutlet weak var map: UIView!
     @IBOutlet weak var MapImageView: customImageView!
    var LatPosition = "0.0"
    var LngPosition = "0.0"
    var address = ""
      var HourFrom = ""
      var HourTo = ""
    var Area_id = ""
       var City_id = ""
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnTus: UIButton!
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    
    var isbtnFri = false
    var isbtnThu = false
    var isbtnWed = false
    var isbtnTus = false
    var isbtnMon = false
    var isbtnSun = false
    var isbtnSat = false

     var http = HttpHelper()
    
    @IBOutlet weak var imageProfile: customImageView!{
        didSet{
            imageProfile.layer.cornerRadius = imageProfile.frame.width/2
            imageProfile.clipsToBounds = true
        }
    }
    
    func setupDaysData(){
        for i in 0...6 {
            var obj:DayModel = DayModel()
            obj.index = i
            obj.isselected = false
            obj.name = daysname[i]
            days.append(obj)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDaysData()
        LoadMapImage(lat: LatPosition, Long: LngPosition)
         SetupUploadImage()
        http.delegate = self
        loadCityData()
        
        
        if isEidtplayground == true{
            isEidtplayground = false
            isEidt = true
            setDataEidt()
        }
        
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        lblTitle.text = Title
        // Do any additional setup after loading the view.
    }
    
    
    func setDataEidt()
    {
      
        txtPrice.text = items?._price
        lblTo.text = items!._hour_to
           lblFrom.text = items!._hour_from
        lblCapacity.text = items?._capacity
        txtAddress.text = items?._address
        txtPhoneNum.text = items?._phone
         txtArabicName.text = items?._name_ar
         txtEnglishName.text = items?._name_en
      txtFees.text = items?._cancel_fee
          txtHours.text = items?._cancelation_time
        imageProfile.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\((items?._image)!)")
        
       
        if items?._days.count == 3 {
            if items?._days == "sat"{
                btnSat.backgroundColor = UIColor.hexColor(string:"#009C9E")
                days[0].isselected = true
            }
            else if items?._days == "sun"{
                btnSun.backgroundColor = UIColor.hexColor(string:"#009C9E")
                days[1].isselected = true
            }
            else if items?._days == "mon"{
                btnMon.backgroundColor = UIColor.hexColor(string:"#009C9E")
                days[2].isselected = true
            }
            else if items?._days == "tue"{
                btnTus.backgroundColor = UIColor.hexColor(string:"#009C9E")
                days[3].isselected = true
            }
            else if items?._days == "wed"{
                btnWed.backgroundColor = UIColor.hexColor(string:"#009C9E")
                days[4].isselected = true
            }
            else if items?._days == "thu"{
                btnThu.backgroundColor = UIColor.hexColor(string:"#009C9E")
                days[5].isselected = true
            }
            else if items?._days == "fri"{
                btnFri.backgroundColor = UIColor.hexColor(string:"#009C9E")
                days[6].isselected = true
            }
            
        }
        else if items?._days.count == 7 {}
        else if items?._days.count == 11 {}
        else if items?._days.count == 15 {}
        else if items?._days.count == 19 {}
        else if items?._days.count == 23 {}
        else if items?._days.count == 26 {}
        
//
//        let start = str.index(str.startIndex, offsetBy: 7)
//        let end = str.index(str.endIndex, offsetBy: -6)
//        let range = start..<end
//
//        let mySubstring = str[range]  // play
    }
    
    func loadCityData(){
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.GetWithoutHeader(url: APIConstants.GetCity, Tag: 2)
    }
    
    func loadAreamData(city_id:String){
        let params = ["country_id":city_id] as [String: Any]
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.GetWithoutHeader(url: APIConstants.GetArea, parameters: params, Tag: 3)
    }
    
    @IBAction func btnTo(_ sender: Any) {
        dateis = "To"
        showDatePicker()
        onDoneButtonTapped()
        datePicker.addTarget(self, action: #selector(AddPlayGroundVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    @IBAction func btnFrom(_ sender: Any) {
        dateis = "From"
        showDatePicker()
        onDoneButtonTapped()
        datePicker.addTarget(self, action: #selector(AddPlayGroundVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    @IBAction func btnCapacity(_ sender: Any) {
        PickerFlag = "Capacity"
        configurePicker()
    }
    @IBAction func btnCity(_ sender: Any) {
         PickerFlag = "City"
        configurePicker()
    }
    @IBAction func btnArea(_ sender: Any) {
    
        loadAreamData(city_id:City_id)
        PickerFlag = "Area"
        
    }
    @IBAction func btnFri(_ sender: Any) {
        if  btnFri.backgroundColor == UIColor.clear {
        btnFri.backgroundColor = UIColor.hexColor(string:"#009C9E")
           days[6].isselected = true
        }else{
            btnFri.backgroundColor = UIColor.clear
                 days[6].isselected = false
        }
    }
    @IBAction func btnThu(_ sender: Any) {
        if  btnThu.backgroundColor == UIColor.clear {
            btnThu.backgroundColor = UIColor.hexColor(string:"#009C9E")
           days[5].isselected = true
        }else{
            btnThu.backgroundColor = UIColor.clear
             days[5].isselected = false
        }
    }
    @IBAction func btnWed(_ sender: Any) {
        if  btnWed.backgroundColor == UIColor.clear {
            btnWed.backgroundColor = UIColor.hexColor(string:"#009C9E")
           days[4].isselected = true
        }else{
            btnWed.backgroundColor = UIColor.clear
             days[4].isselected = false
        }
    }
    @IBAction func btnTus(_ sender: Any) {
        if  btnTus.backgroundColor == UIColor.clear {
            btnTus.backgroundColor = UIColor.hexColor(string:"#009C9E")
             days[3].isselected = true
        }else{
            btnTus.backgroundColor = UIColor.clear
             days[3].isselected = false
        }
    }
    @IBAction func btnMon(_ sender: Any) {
        if  btnMon.backgroundColor == UIColor.clear {
            btnMon.backgroundColor = UIColor.hexColor(string:"#009C9E")
            days[2].isselected = true
        }else{
            btnMon.backgroundColor = UIColor.clear
          days[2].isselected = false
        }
    }
    @IBAction func btnSun(_ sender: Any) {
        if  btnSun.backgroundColor == UIColor.clear {
            btnSun.backgroundColor = UIColor.hexColor(string:"#009C9E")
          
             days[1].isselected = true
        }else{
            btnSun.backgroundColor = UIColor.clear
            
            
             days[1].isselected = false
        }
    }
    @IBAction func btnSat(_ sender: Any) {
        
        if  btnSat.backgroundColor == UIColor.clear {
            btnSat.backgroundColor = UIColor.hexColor(string:"#009C9E")
            
            days[0].isselected = true
        }else{
            btnSat.backgroundColor = UIColor.clear
            
             days[0].isselected = false
        }
    }
    @IBAction func btnAddPlayGround(_ sender: Any) {
        if isEidt == true
        {
            isEidt = false
            
            Editlayground()
        }else{
        Addplayground()
        }
    }
    
    func configurePicker (){
        
        picker  = UIPickerView()
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
        
        //  DPicker.addTarget(self, action: #selector(AddPlayGroundVC.ChangeDate(sender:)), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func datePickerValueChanged (datePicker: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.none
        dateformatter.timeStyle = DateFormatter.Style.long
        let dateValue = dateformatter.string(from: datePicker.date)
        let datee = dateformatter.date(from: dateValue)
        dateformatter.dateFormat = "a"
        let hpm = dateformatter.string(from: datee!)
        if hpm == "PM" {
            dateformatter.dateFormat = "HH"
            let hou = dateformatter.string(from: datee!)
            dateformatter.dateFormat = "mm"
            let Min = dateformatter.string(from: datee!)
            dateformatter.dateFormat = "ss"
            //  let Sec = dateformatter.string(from: datee!)
            let Time24 = "\(hou):\(Min):00"

        
        if dateis == "From" {
            lblFrom.text = Time24
        }else{
            lblTo.text = Time24
        }
            
        }else {
            
            dateformatter.dateFormat = "HH:mm:00"
            let Time24 = dateformatter.string(from : datee!)
            if dateis == "From" {
                lblFrom.text = Time24
            }else{
                lblTo.text = Time24
            }
        }

        
    }
    
    func showDatePicker(){
        
        datePicker.datePickerMode = .time
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        self.view.addSubview(toolbar)
        
        let tempInput = UITextField( frame:CGRect.zero )
        tempInput.inputView = self.datePicker       // Your picker
        self.view.addSubview( tempInput )
        tempInput.becomeFirstResponder()
        
    }
    @objc func donedatePicker(){
        self.view.endEditing(true)
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if PickerFlag == "Capacity"
        {
        return TeamCapacity.count
        }else if PickerFlag == "City"{
           return CityArray.count + 1
        }else{
          return  AreaArray.count  + 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if PickerFlag == "Capacity"
        {
        if row == 0{
            return AppCommon.sharedInstance.localization("PLAYGROUND CAPACITY")
        }
        return String(TeamCapacity[row])
        }
        else if PickerFlag == "City"{
            if row == 0{
                return  AppCommon.sharedInstance.localization("ChoseCity")
            }else {
                
                if SharedData.SharedInstans.getLanguage() == "en"
                {
                    return CityArray[row-1].name_en
                }else
                {
                    return CityArray[row-1].name_ar
                }
                
            }
            
        }else{
            if row == 0{
                return  AppCommon.sharedInstance.localization("ChoseArea")
            }else {
                
                if SharedData.SharedInstans.getLanguage() == "en"
                {
                    return AreaArray[row-1].name_en
                }else
                {
                    return AreaArray[row-1].name_ar
                }
                
            }
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if PickerFlag == "Capacity"
        {
            lblCapacity.text = String(TeamCapacity[row])
            
        }
        else if PickerFlag == "City"{
            
            if CityArray.count != 0 {
                if row == 0 {
                    lblCity.text = nil
                    
                }else {
                    if SharedData.SharedInstans.getLanguage() == "en"
                    {
                        lblCity.text = CityArray[row-1].name_en
                    }else
                    {
                        lblCity.text = CityArray[row-1].name_ar
                    }
                   City_id = CityArray[row-1].id
                   
                }
            }
        }
        
        else{
            if AreaArray.count != 0 {
                if row == 0 {
                    lblAream.text = nil
                    
                }else {
                    if SharedData.SharedInstans.getLanguage() == "en"
                    {
                        lblAream.text = AreaArray[row-1].name_en
                    }else
                    {
                        lblAream.text = AreaArray[row-1].name_ar
                    }
                     Area_id = AreaArray[row-1].id
                   
                   
                }
            }
            
        }
    }
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension AddPlayGroundVC: shareLocationDelegate {
    func shareLocationDelegate(lat: String, Long: String){
        self.tabBarController?.tabBar.isHidden = false
        print(lat,Long)
        self.LatPosition = lat
        self.LngPosition = Long
        LoadMapImage(lat: lat, Long: Long)
        
    }
    
    func LoadMapImage(lat: String, Long: String)
    {
        
        let Lat = lat
        let Lng = Long
        let staticMapUrl: String = "http://maps.google.com/maps/api/staticmap?markers=color:red|\(Lat),\(Lng)&\("zoom=17&size=\(2 * Int(MapImageView.frame.size.width))x\(2 * Int(MapImageView.frame.size.height))")&sensor=true"
        
        let mapul = "https://maps.google.com/maps/api/staticmap?key=AIzaSyB-3KGui1I1wguVGxALFNa5cld4ijK8fS4&markers=color:red|\(Lat),\(Lng)&\("zoom=17&size=\(2 * Int(MapImageView.frame.size.width))x\(2 * Int(MapImageView.frame.size.height))")&sensor=true&fbclid=IwAR2rsCS0d9D-aow4D3AWs9-fv3EdiSDsFFUU80Gm6oQ7vCZwlXUaPjUOmU8"
        
        let urlI = URL(string: mapul.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if let url = urlI {
            print("map: \(urlI!)")
            MapImageView.loadimageUsingUrlString(url: mapul)
        } else{
            print("map: \(urlI)")
            print("nil")
        }
        
    }
    
    
    ////// func that return english numbers from arabic numbers
    
    func convertEnToArNum(Numtxt : String) -> String{
      //  let numberStr: String = "٨٦٩١٢٨٨١"
        var returnstr = ""
        let num = Int(Numtxt)
        if num != nil {
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
            let final = formatter.number(from: Numtxt)
            let doubleNumber = Double(truncating: final!)
            returnstr = String(doubleNumber)
        }else{
            returnstr = "default"
        }
        return returnstr
    }
    
    // chose location
    @IBAction func openMapToShareLocation(_ sender: UIButton) {
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle: nil)
        let secondView = storyBoard.instantiateViewController(withIdentifier: "ChooseLocationToShareViewController") as! ChooseLocationToShareViewController
        secondView.shareLocationDelegate = self
        self.show(secondView, sender: true)
        //        show(secondView, sender: nil)
        
    }
    
}
extension AddPlayGroundVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    func SetupUploadImage()
    {
        AlertController = UIAlertController(title:"" , message:AppCommon.sharedInstance.localization("Choose Image") , preferredStyle: UIAlertController.Style.actionSheet)
        
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
    
    @IBAction func UpdateImage(_ sender: UIButton) {
        Imagepicker.delegate = self
        Imagepicker.allowsEditing = false
        self.present(AlertController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageProfile.image = selectedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
 // add playground
extension AddPlayGroundVC {
    
    
//    func setupPara() ->  [String: Any] {
//    var parameters = [:] as [String: Any]
//
//        var count = 1
//        for  i in days
//        {
//            if i.isselected == true{
//                parameters["day[\(count)]"] = [i.name]
//            }
//            count += 1
//        }
//
//
//
//        return parameters
//    }
    
    
    func Addplayground() {
       
        
    
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        var parameters = [:] as [String: Any]
        print(AccessToken)
        let imgdata = self.imageProfile.image!.jpegData(compressionQuality: 0.5)
        print(AccessToken)
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-type": "multipart/form-data",
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
    
        ]
        
        let Enprice = convertEnToArNum(Numtxt: txtPrice.text ?? "def")
        let EnHours = convertEnToArNum(Numtxt: txtHours.text ?? "def")
        let Enfees = convertEnToArNum(Numtxt: txtFees.text ?? "def")
        print("\(Enprice)  \(EnHours)  \(Enfees)")
        
        parameters = [
            "name_en" : txtEnglishName.text!,
            "name_ar" : txtArabicName.text!,
            "lat" : LatPosition,
             "lng": LngPosition,
            "image" :  imgdata!,
            "price" : Enprice,
            "capacity" : lblCapacity.text!,
            "cancelation_time" : EnHours,
            "cancel_fee" :Enfees,
            "address" :txtAddress.text!,
            "hour_from" : lblFrom.text!,
            "hour_to" : lblTo.text!,
            "city_id": Area_id,
            "phone" : txtPhoneNum.text!
           
        ]
        
        var count = 0
                for  i in days
                {
                    if i.isselected == true{
                        parameters["day[\(count)]"] = i.name
                        count += 1
                    }
                    
                }
        
        print(parameters)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameters {
                    if let value = value as? String {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
                if let data = self.imageProfile.image!.jpegData(compressionQuality: 0.5){
                    multipartFormData.append(data, withName: "image", fileName: "image\(arc4random_uniform(100))"+".jpeg", mimeType: "jpeg")
                    
                }
                
        },
            usingThreshold:UInt64.init(),
            to: "http://172.107.175.8/api/owner/add-ground",
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
                            print(message)
                            
                            if status.stringValue == "1" {
                                  Loader.showSuccess(message: AppCommon.sharedInstance.localization("PlayGround Added Successfuly"))
                                
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                            else{
                                Loader.showError(message: message.stringValue)
                            }
                        }
                        else {
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
    
    
    /////// edit playground
    
    func Editlayground() {
        
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        var parameters = [:] as [String: Any]
        print(AccessToken)
        let imgdata = self.imageProfile.image!.jpegData(compressionQuality: 0.5)
        print(AccessToken)
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-type": "multipart/form-data",
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
            
        ]
        
        
        let Enprice = convertEnToArNum(Numtxt: txtPrice.text ?? "def")
        let EnHours = convertEnToArNum(Numtxt: txtHours.text ?? "def")
        let Enfees = convertEnToArNum(Numtxt: txtFees.text ?? "def")
        print("\(Enprice)  \(EnHours)  \(Enfees)")
        
        parameters = [
            "name_en" : txtEnglishName.text!,
            "name_ar" : txtArabicName.text!,
            "lat" : LatPosition,
            "lng": LngPosition,
            "image" :  imgdata!,
            "price" : Enprice,
            "capacity" : lblCapacity.text!,
            "cancelation_time" : EnHours,
            "cancel_fee" :Enfees,
            "address" :txtAddress.text!,
            "hour_from" : lblFrom.text!,
            "hour_to" : lblTo.text!,
            "city_id": Area_id,
            "phone" : txtPhoneNum.text!,
            "ground_id": items!._id
            
        ]
        
        var count = 0
        for  i in days
        {
            if i.isselected == true{
                parameters["day[\(count)]"] = i.name
                count += 1
            }
            
        }
        
        print(parameters)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameters {
                    if let value = value as? String {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
                if let data = self.imageProfile.image!.jpegData(compressionQuality: 0.5){
                    multipartFormData.append(data, withName: "image", fileName: "image\(arc4random_uniform(100))"+".jpeg", mimeType: "jpeg")
                    
                }
                
        },
            usingThreshold:UInt64.init(),
            to: "http://172.107.175.8/api/owner/ground-ios-update",
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
                            print(message)
                            
                            if status.stringValue == "1" {
                                Loader.showSuccess(message: AppCommon.sharedInstance.localization("PlayGround edit Successfuly"))
                                
                                self.dismiss(animated: true, completion: nil)
                            }
                                
                            else{
                                Loader.showError(message: message.stringValue)
                            }
                        }
                        else {
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

extension AddPlayGroundVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        if Tag == 1 {
          
           
        }
            
        else if Tag == 2 {
            
            let json = JSON(dictResponse)
            let Result =  JSON(json["data"])
            let message = json["message"]
            let status =  JSON(json["status"])
            print(Result)
       
            print(status)
            CityArray.removeAll()
            if status.stringValue == "1" {
                let result =  json["data"].arrayValue
                for json in result{
                    let obj = CityModelClass(
                        id: json["id"].stringValue,
                        name_en: json["name_en"].stringValue,
                        name_ar: json["name_ar"].stringValue,
                        name: json["name"].stringValue)
                    CityArray.append(obj)
                    
                }
                
               
                
            } else {
                
                Loader.showError(message: message.stringValue)
            }
        }
            
        else if Tag == 3 {
            let json = JSON(dictResponse)
            let Result =  JSON(json["data"])
            let message = json["message"]
            let status =  JSON(json["status"])
            print(Result)
            
            print(status)
            CityArray.removeAll()
            if status.stringValue == "1" {
                let result =  json["data"].arrayValue
                for json in result{
                    let obj = AreaModelClass(
                        id: json["id"].stringValue,
                        name_en: json["name_en"].stringValue,
                        name_ar: json["name_ar"].stringValue,
                        name: json["name"].stringValue)
                    AreaArray.append(obj)
                    
                }
                
                configurePicker()
                
            } else {
                
                Loader.showError(message: message.stringValue )
            }
     }
            
       
    }
    
    func receivedErrorWithStatusCode(statusCode: Int) {
        print(statusCode)
        AppCommon.sharedInstance.alert(title: "Error", message: "\(statusCode)", controller: self, actionTitle: AppCommon.sharedInstance.localization("ok"), actionStyle: .default)
        
        AppCommon.sharedInstance.dismissLoader(self.view)
    }
    
    func retryResponse(numberOfrequest: Int) {
        
    }
}
