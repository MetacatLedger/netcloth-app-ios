







import Foundation
import Alamofire

extension AFDataResponse {
    func isValid() -> Bool {
        return (self.response?.statusCode ?? 0) >= 200 && (self.response?.statusCode ?? 0) <= 299
    }
}

enum NW {
    
    
    static func requestUrl(path:String,
                           method: HTTPMethod = .get,
                           para:Parameters? = nil,
                           complete: ((_ success:Bool, _ value:Any?) -> Void)? = nil) {
        
        AF.request(path, method: method, parameters: para).responseJSON { ( res:AFDataResponse<Any>) in
            guard let cb = complete else {
                return
            }
            cb(res.value != nil && res.isValid(), res.value)
        }
    }
    
    static func getJsonUrl(path:String,
                           method: HTTPMethod = .get,
                           para:Parameters? = nil,
                           complete: @escaping ((_ success:Bool, _ value:Any?) -> Void)) {
        
        AF.request(path, method: method, parameters: para).responseJSON { ( res:AFDataResponse<Any>) in
            let cb = complete
            cb(res.value != nil && res.isValid(), res.value)
        }
    }
    
    
    static func getDataUrl(path:String,
                           method: HTTPMethod = .get,
                           para:Parameters? = nil,
                           complete: ((_ success:Bool, _ value:Any?) -> Void)? = nil) {
        
        AF.request(path, method: method, parameters: para).responseData { (res) in
            guard let cb = complete else {
                return
            }
            cb(res.value != nil && res.isValid() , res.data)
        }
    }
    
    
    
    
    
    
    
    
    
    
    static func uploadData(data: Data,
                           toUrl: String,
                           complete: ((_ success:Bool, _ value:Any?) -> Void)? = nil,
                           uploadProgress: ((Double) -> Void)? = nil ) {
        
        
        let request =
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "uploadfile", fileName: "uploadfile", mimeType: "*/*")
        }, to: toUrl).responseJSON { response in
            
            guard let cb = complete else {
                return
            }
            cb(response.value != nil && response.isValid(), response.value)
        }
        
        if uploadProgress != nil {
            request.uploadProgress { (progress) in
                uploadProgress!(progress.fractionCompleted)
            }
        }
    }
}

extension NW {
    
    static func uploadHttp(body: Data,
                           toUrl: String,
                           method: String? = "POST",
                           headers: HTTPHeaders? = nil,
                           complete: ((_ success:Bool, _ value:Data?) -> Void)? = nil) {
        let rv =  method?.uppercased() ?? "POST"
        let method_a = Alamofire.HTTPMethod(rawValue:rv)
        
        AF.upload(body, to: toUrl, method: method_a, headers: headers).responseData { (res) in
            guard let cb = complete else {
                return
            }
            cb(res.isValid(), res.data)
        }
    }
}
