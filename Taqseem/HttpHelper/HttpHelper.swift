//
//  HttpController.swift
//  AshakAlena
//
//  Created by Mohammad Farhan on 22/12/177/25/17.
//  Copyright © 2017 Mohammad Farhan. All rights reserved.
//

import Foundation
import Alamofire
protocol HttpHelperDelegate {
    func receivedResponse(dictResponse:Any,Tag:Int)
    func receivedErrorWithStatusCode(statusCode:Int)
    func retryResponse(numberOfrequest:Int)
}
/// HttpHelper class for http request using alamofire libs
class HttpHelper{
    /// **HttpHelparDelegate**  interface on complete request call
    var delegate: HttpHelperDelegate?
    
    var header:HTTPHeaders?
    var numberOfrequest = 0
    var maxNumberOfrequest = 3
    /**
     It get request
     
     ### Usage Example: ###
     ````
     let request = HttpHelper()
     
     request.Get("http://....",parameters:["user":"me"],Tag:1)
     
     ````
     - parameter Url:        The URL.
     - parameter parameters: The parameters. `[:]` by default.
     - parameter Tag:   The parameter tag per request.
     */
    
    
//    func RequestWithBodyAndHeader(url : URL, method: HTTPMethod, params: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders) {
//        Alamofire.request(APIConstants.LOGIN , method: method, parameters: params, encoding: JSONEncoding.default,headers: headers).responseJSON
//            {
//                response in
//                debugPrint(response)
//                print(response)
//        }
//
//    }
    
    
    
    
    public  func Get(url:String,parameters:Parameters=[:],Tag:Int , headers:HTTPHeaders){
        
        
        request(url: url, method: .get, parameters: parameters, tag: Tag,header: headers)
    }
    
    
    public  func GetWithoutHeader(url:String,parameters:Parameters=[:],Tag:Int ){
        
        
        request(url: url, method: .get, parameters: parameters, tag: Tag,header: nil)
    }
    
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any]){
        
        let url = "http://google.com" /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data",
            "lang":SharedData.SharedInstans.getLanguage()
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
//                        onError?(err)
                        return
                    }
//                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
//                onError?(error)
            }
        }
    }

    
    
    /**
     It post request
     
     ### Usage Example: ###
     ````
     let request = HttpHelper()
     
     request.Post("http://....",parameters:["user":"me"],Tag:1)
     
     ````
     - parameter Url:        The URL.
     - parameter parameters: The parameters. `[:]` by default.
     - parameter Tag:   The parameter tag per request.
     
     */
    public func Post(url:String,parameters:Parameters=[:],Tag:Int, headers:HTTPHeaders ){
        request(url: url, method: .post, parameters: parameters, tag: Tag,header: headers)
    }
    
    public func PostWithBody(url:String,parameters:Parameters=[:],Tag:Int, hasAuthorized:Bool=false){
        requestWithBody(url: url, method: .post, parameters: parameters, tag: Tag,header: hasAuthorized ? header : nil)
    }

    
    /**
     It patch request
     
     ### Usage Example: ###
     ````
     let request = HttpHelper()
     
     request.Patch("http://....",parameters:["user":"me"],Tag:1)
     
     ````
     - parameter Url:        The URL.
     - parameter parameters: The parameters. `[:]` by default.
     - parameter Tag:   The parameter tag per request.
     
     */
    public func Patch(url:String,parameters:Parameters=[:],Tag:Int, hasAuthorized:Bool=false){
        
        
        request(url: url, method: .patch, parameters: parameters, tag: Tag,header: hasAuthorized ? header : nil)
    }
    
    /**
     Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of the specified `url`,
     `method`, `parameters`, `tag`.
     - parameter url:The URL.
     - parameter method:     The HTTP method. `.get` by default.
     - parameter parameters: The parameters. `nil` by default.
     - parameter Tag:   The parameter tag per request.
     - returns: The created `DataRequest` using interface **HttpHelparDelegate**.
     */
    
    
    public func requestWithBody (url:String,method:HTTPMethod,parameters:Parameters=[:],tag:Int,header:HTTPHeaders?) {
        
        print(url)
        Alamofire.request(url , method: method, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            debugPrint(response)
            if response.response == nil {
                self.delegate?.receivedErrorWithStatusCode(statusCode: statusCode.NOT_FOUND)
                return
            }
            if response.response!.statusCode == statusCode.OK  || response.response!.statusCode == statusCode.CREATED
                || response.response!.statusCode == statusCode.NO_CONTENT || response.response!.statusCode == statusCode.ACCEPTED{
                if let JSON = response.result.value {
                    //                        logger(.value, message: JSON)
                    self.delegate?.receivedResponse(dictResponse: JSON,Tag: tag)
                }
            }else if response.response!.statusCode == statusCode.BAD_GATEWAY || response.response!.statusCode == statusCode.SERVICE_UNAVAILABLE{
                let when = DispatchTime.now() + Double(0.1 * Double(self.numberOfrequest))
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    self.delegate?.retryResponse(numberOfrequest: self.numberOfrequest)
                    self.numberOfrequest  = self.numberOfrequest +  1
                }
            }else{
                self.delegate?.receivedErrorWithStatusCode(statusCode: response.response!.statusCode)
            }
        }

    }
    
    
    
    
    private func request(url:String,method:HTTPMethod,parameters:Parameters=[:],tag:Int,header:HTTPHeaders?){
//        logger(.value, message: url)
//        logger(.value, message: parameters
        
        Alamofire.request(url, method: method,parameters: parameters,headers:header)
            .responseJSON { (response) in
                print(response)
                if response.response == nil {
                    self.delegate?.receivedErrorWithStatusCode(statusCode: statusCode.NOT_FOUND)
                    return
                }
                if response.response!.statusCode == statusCode.OK  || response.response!.statusCode == statusCode.CREATED
                    || response.response!.statusCode == statusCode.NO_CONTENT || response.response!.statusCode == statusCode.ACCEPTED{
                    if let JSON = response.result.value {
//                        logger(.value, message: JSON)
                        self.delegate?.receivedResponse(dictResponse: JSON,Tag: tag)
                    }
                }else if response.response!.statusCode == statusCode.BAD_GATEWAY || response.response!.statusCode == statusCode.SERVICE_UNAVAILABLE{
                    let when = DispatchTime.now() + Double(0.1 * Double(self.numberOfrequest))
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        // Your code with delay
                        self.delegate?.retryResponse(numberOfrequest: self.numberOfrequest)
                        self.numberOfrequest  = self.numberOfrequest +  1
                    }
                }else{
                    self.delegate?.receivedErrorWithStatusCode(statusCode: response.response!.statusCode)
                }
        }
    }
}

