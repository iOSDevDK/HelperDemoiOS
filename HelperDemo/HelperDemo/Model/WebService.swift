//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

let WS_MacLocal = "http://192.168.1.13/TeamsnapApp/index.php/V1"
let WS_Staging = "http://23.235.210.245/~thegcc5/TeamSnap/index.php/V1"
let WS_Live = "https://proinbox.co.tz/api/v1"
let kGoogleApi = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address="

let kBASEURL =  WS_Staging
//let kBASEURL =  WS_MacLocal

typealias messageCallbackWithData = (([String: AnyObject]) -> Void)
typealias successCallbackWithData = (([String: AnyObject]) -> Void)
typealias successCallback = (() -> Void)
typealias errorCallback = ((Error) -> Void)

class WebService {
    
    //------------------------------------------------------------------
    
    
    
    static func callWebService(strAPI: String,methodType: HTTPMethod ,requestParams: [String:String],successCompletionHandler: @escaping successCallbackWithData,  messageCallBackHandler: @escaping messageCallbackWithData, errorHandler: @escaping errorCallback) {
        
        let urlString = "\(kBASEURL)/\(strAPI)"
        print("urlString = ",urlString)
        Alamofire.request(urlString,method: methodType, parameters: requestParams, encoding: JSONEncoding.default, headers: [:]).validate().responseJSON { (response :DataResponse<Any>) in
            
            switch response.result {
            case .success:
                if let responseDict = response.result.value as? [String: AnyObject] {
                    print(response)
                    if response.response?.statusCode == 200 {
                        successCompletionHandler(responseDict)
                    } else {
                        // Display Alert.
                    }
                } else {
                    print("resp = ",response.result.value as! [AnyObject])
                    if response.response?.statusCode == 200 {
                        successCompletionHandler(["paid_status_api":(response.result.value as! [AnyObject]) as AnyObject])
                    } else {
                        // Display Alert.
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    appDel.hideProgress()
                }
                //errorHandler(error.localizedDescription)
                errorHandler(error)
            }
            
        }
    }
    
    static func callGetWebService(strAPI: String,methodType: HTTPMethod ,requestParams: [String:AnyObject],successCompletionHandler: @escaping successCallbackWithData,  messageCallBackHandler: @escaping messageCallbackWithData, errorHandler: @escaping errorCallback) {
        
    }
    
    //------------------------------------------------------------------
    
    static func callPostWebService(strAPI: String,requestParams: [String:String],successCompletionHandler: @escaping successCallbackWithData,  messageCallBackHandler: @escaping messageCallbackWithData, errorHandler: @escaping errorCallback) {
        
        let urlString = "\(kBASEURL)/\(strAPI)"
        print("urlString = ",urlString)
        
        //Alamofire.request(urlString, method: .post, parameters: requestParams, encoding: URLEncoding.default)
        Alamofire.request(urlString, method: .post, parameters: requestParams, encoding: URLEncoding.default).validate().responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                if let responseDict = response.result.value as? [String: AnyObject] {
                    print(response)
                    if response.response?.statusCode == 200 {
                        
                        successCompletionHandler(responseDict)
                    } else {
                        // Display Alert.
                    }
                } else {
                    print("resp = ",response.result.value as! [AnyObject])
                    if response.response?.statusCode == 200 {
                        successCompletionHandler(["key":(response.result.value as! [AnyObject]) as AnyObject])
                    } else {
                        // Display Alert.
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    appDel.hideProgress()
                }
                //errorHandler(error.localizedDescription)
                errorHandler(error)
            }
        }
    }
    
    //------------------------------------------------------------------
    
    static func callUploadPostWebService(strAPI: String,img:UIImage,requestParams: [String:String],successCompletionHandler: @escaping successCallbackWithData,  messageCallBackHandler: @escaping messageCallbackWithData, errorHandler: @escaping errorCallback) {
        
        let urlString = "\(kBASEURL)/\(strAPI)"
        print("urlString = ",urlString)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData = UIImageJPEGRepresentation(img, 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "imgUser.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in requestParams {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:urlString ) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    print(response)
                    
                    if let responseDict = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            
                            successCompletionHandler(responseDict)
                        }
                    } else {
                        //print("resp = ",response.result.value as! [AnyObject])
                        if response.response?.statusCode == 200 {
                            successCompletionHandler(["key":(response.result.value as! [AnyObject]) as AnyObject])
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    appDel.hideProgress()
                }
                //errorHandler(error.localizedDescription)
                errorHandler(error)
            }
        }
    }
    
    static func callGoogleWebService(strAddress: String,methodType: HTTPMethod ,successCompletionHandler: @escaping successCallbackWithData,  messageCallBackHandler: @escaping messageCallbackWithData, errorHandler: @escaping errorCallback) {
        
        let strEndoginrURL = strAddress.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlString = "\(kGoogleApi)/\(strEndoginrURL!)"
        print("urlString = ",urlString)
        
        //Alamofire.request
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default).validate()
            .responseJSON { response in
                //print(response)
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? [String: AnyObject] {
                        //print(response)
                        if response.response?.statusCode == 200 {
                            successCompletionHandler(responseDict)
                        } else {
                            // Display Alert.
                        }
                    } else {
                        //print("resp = ",response.result.value as! [AnyObject])
                        if response.response?.statusCode == 200 {
                            successCompletionHandler(["key":(response.result.value as! [AnyObject]) as AnyObject])
                        } else {
                            // Display Alert.
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        appDel.hideProgress()
                    }
                    //errorHandler(error.localizedDescription)
                    errorHandler(error)
                }
        }
        
    }
}
