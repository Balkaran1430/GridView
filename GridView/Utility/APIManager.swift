
import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()

    private init() {}
    
    func request(url:String,method:HTTPMethod,parameters:Parameters?=nil,tryAgain:Bool=true,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String?) -> Void) {

        print(url)
        print(parameters as Any)
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (response) in
            
            print(response.value as Any)
            
            completionCallback(response as AnyObject)

            if self.isResponseValid(response: response) {

                switch response.result {
                case .success(let responseJSON):
                    successCallback(responseJSON as AnyObject)
                case .failure(let error):
                    failureCallback(error.localizedDescription)
                }
            } else {
                let error =  self.getErrorForResponse(response: response)
                
                failureCallback(error)
                
            }
        }
    }
    
    func requestWithoutHeader(url:String,method:HTTPMethod,parameters:Parameters?=nil,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String?) -> Void) {

        
        let headers: HTTPHeaders = [:]
        URLCache.shared.removeAllCachedResponses()
        print(parameters as Any)

        print(url)
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in

            print(response.value as Any)

            completionCallback(response as AnyObject)
            
            if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    successCallback(responseJSON as AnyObject)
                case .failure(let error):
                    failureCallback(error.localizedDescription)
                }
            } else {
                let error =  self.getErrorForResponse(response: response)
                failureCallback(error)
            }
        }
    }
    

    
    //MARK:- Validation (Check response is valid or not)
    //MARK:-
     private func isResponseValid(response: AFDataResponse<Any>) -> Bool {
        if let statusCode = response.response?.statusCode, statusCode < 200 || statusCode >= 300 {
            return false
        }
        
        if let isSuccess = (response.value as AnyObject)["flag"] as? Bool {
            return isSuccess
        } else if let isSuccess = (response.value as AnyObject)["flag"] as? String {
            if isSuccess == "1" {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
     func getErrorForResponse(response: AFDataResponse<Any>) -> String? {
        switch response.result {
        case .success(let responseJSON):
            if let responseDictionary = responseJSON as? [String: Any] {
                if let errorMessage = responseDictionary["message"] as? String {
                      return errorMessage
                }
                
                if let errorMessage = responseDictionary["response"] as? String {
                    return errorMessage
                }

                return responseDictionary.description
            }
            return nil
        case .failure(let errorObj):
            return errorObj.localizedDescription
        }
    }
    
}

