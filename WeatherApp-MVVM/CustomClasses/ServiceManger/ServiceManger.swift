//
//  ServiceManger.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import Foundation
import Alamofire

let ServiceManager = AIServiceManager.shared

class AIServiceManager: NSObject {
    
    // MARK: - SHARED MANAGER
    static let shared = AIServiceManager()

    var mimeType:String = ""
    
    // MARK: - API CALL Function
    func callGETApiWithNetCheck(url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        callGET_POSTApiWithNetCheck(isGet: true, url: url, headersRequired: headersRequired, params: params, completionHandler: completionHandler)
    }

    func callPOSTApiWithNetCheck(url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void){
        callGET_POSTApiWithNetCheck(isGet: false, url: url, headersRequired: headersRequired, params: params, completionHandler: completionHandler)
    }
    
    //MARK:- ******** COMMON POST METHOD *********
    private func callGET_POSTApiWithNetCheck(isGet:Bool, url : String, headersRequired : Bool, params : [String : Any]?, completionHandler : @escaping (AFDataResponse<Any>?,Bool) -> Void) {

        if(!IS_INTERNET_AVAILABLE()){
            SHOW_INTERNET_ALERT()
            completionHandler(nil,false)
            return
        }
        
        var  headers: HTTPHeaders? = nil
        var parameter = params
        if headersRequired {
            headers = [
                "Accept": "application/json"
            ]
        }
        
        print("\n\nService URL : \(url)")
        print("Service PARAM : \(params ?? [:])")
        print("Service HEADERs : \(headers?.dictionary ?? [:])")
        
        AF.request(url, method: (isGet ? .get : .post), parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in

            switch response.result {
            case .success(let JSON):
                
                //JSON string log
                do {
                    let data = try JSONSerialization.data(withJSONObject: JSON, options: [])
                    let string = String(data: data, encoding: .utf8)
                    print("Response : ",string ?? "--")
                }catch {
                    print("Response parsing error")
                }
                
                //print("\((url as NSString).lastPathComponent) JSON :: \(JSON) \n\n")
                if JSON is NSDictionary
                {
                    let dictJson = JSON as! NSDictionary
                    let status = dictJson.value(forKey: "cod") as? String ?? "0"
                    if (status == "200") {
                        completionHandler(response,true)
                        
                    }else {
                        completionHandler(response, false)
                    }
                    
                } else  {
                    print("J S O N \(JSON)")
                    completionHandler(response,false)
                }

            case .failure( _):
                completionHandler(response,false)
            }
        }
    }
}



/*
AF.request(url, method: (isGet ? .get : .post), parameters: params, encoding: URLEncoding.queryString, headers: headers).responseDecodable(of: Forecast.self) { response in
    switch response.result {
    case let .success(data):
        print(data)
        break
       // completionHandler(data, true)
    case let .failure(error): break
        //completionHandler(nil, error)
    }
}
*/
