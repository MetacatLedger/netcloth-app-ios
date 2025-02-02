







import Foundation
import Alamofire

extension AFDataResponse {
    func isValid() -> Bool {
       return (self.response?.statusCode ?? 0) >= 200 && (self.response?.statusCode ?? 0) <= 299
    }
}

@objc public
class CPNetWork: NSObject {
    
    /*
     public enum HTTPMethod: String {
         case connect = "CONNECT"
         case delete  = "DELETE"
         case get     = "GET"
         case head    = "HEAD"
         case options = "OPTIONS"
         case patch   = "PATCH"
         case post    = "POST"
         case put     = "PUT"
         case trace   = "TRACE"
     }
     */
    
    
    @objc public
    static func requestUrl(path:String,
                           method: String,
                           para:Parameters? = nil,
                           complete: ((_ success:Bool, _ value:Any?) -> Void)? = nil) {
        
        let method_a = Alamofire.HTTPMethod(rawValue: method) ?? HTTPMethod.get
        AF.request(path, method: method_a, parameters: para).responseJSON { (res:AFDataResponse<Any>) in
            guard let cb = complete else {
                return
            }
            cb(res.value != nil && res.isValid(), res.value)
        }
    }

    
    @objc public
    static func getDataUrl(path:String,
                           method: String,
                           para:Parameters? = nil,
                           complete: ((_ success:Bool, _ value:Any?) -> Void)? = nil) {
        let method_a = Alamofire.HTTPMethod(rawValue: method) ?? HTTPMethod.get
        AF.request(path, method: method_a, parameters: para).responseData { (res) in
            guard let cb = complete else {
                return
            }
            cb(res.value != nil && res.isValid(), res.data)
        }
    }
    
    
    @objc public
    static func getCacheDataUrl(path:String,
                                cacheRsp:((_ value:Data?) -> Void)? = nil,
                                fetchComplete: ((_ success:Bool, _ value:Data?) -> Void)? = nil) {
        
        
        let method_a = HTTPMethod.get
        
        
        if let request = try? URLRequest(url: path.asURL(), method: method_a, headers: nil),
            let rspCallback = cacheRsp {
            if let urlrequest = try? URLEncoding.default.encode(request, with: nil) {
                let cachedURLResponse  = URLCache.shared.cachedResponse(for: urlrequest)
                rspCallback(cachedURLResponse?.data)
            }
        }
        
        AF.request(path, method: method_a, parameters: nil).responseData { (res) in
            guard let cb = fetchComplete else {
                return
            }
            cb(res.value != nil && res.isValid(), res.data)
        }
    }


    
    
    
    
    
    
    
    @objc public
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
    
    
    @objc public
    static func uploadImageData(data: Data,
                           toUrl: String,
                           fromPubkey: String,
                           complete: ((_ success:Bool, _ value:Any?) -> Void)? = nil,
                           uploadProgress: ((Double) -> Void)? = nil ) {

        let request =
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "uploadfile", fileName: "uploadfile", mimeType: "*/*")
            
            if let pbkeyData = fromPubkey.data(using: String.Encoding.utf8) {
                multipartFormData.append(pbkeyData, withName: "pub_key", fileName: "pub_key", mimeType: "*/*")
            }
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

extension CPNetWork {
    
    @objc public
    static func uploadHttp(body: Data,
                           toUrl: String,
                           method: String? = "POST",
                           complete: ((_ success:Bool, _ value:Data?) -> Void)? = nil) {
        let rv =  method?.uppercased() ?? "POST"
        let method_a = Alamofire.HTTPMethod(rawValue:rv)

        AF.upload(body, to: toUrl, method: method_a).responseData { (res) in
            guard let cb = complete else {
                return
            }
            cb(res.isValid(), res.data)
        }
    }
}
