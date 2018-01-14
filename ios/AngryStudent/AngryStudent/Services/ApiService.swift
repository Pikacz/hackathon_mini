import Foundation
import PromiseKit
import Alamofire


fileprivate func getServerUrl() -> String {
  return "http://192.168.100.250:8090/api2"
}


fileprivate func randomString(length: Int) -> String {
  
  let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  let len = UInt32(letters.length)
  
  var randomString = ""
  
  for _ in 0 ..< length {
    let rand = arc4random_uniform(len)
    var nextChar = letters.character(at: Int(rand))
    randomString += NSString(characters: &nextChar, length: 1) as String
  }
  
  return randomString
}


class ApiService {
  static let RETRY_LIMIT = 1
  let baseUrl: String = getServerUrl()
  let alamofireManager: SessionManager
  
  
  let indoorAppId: String = "7c14025c-47d0-496a-9e3f-5f3a9cf008b5"
  
  
  let userId: String = UIDevice.current.identifierForVendor?.uuidString ?? randomString(length: 50)
  
  
  var spamLocationListener: SpamLocationListener?
  
  static let defaultInstance: ApiService = ApiService()
  
  let indoorMiNI: String = "CScrSxCVhQg"
  
  enum ApiError: Error {
    case missingParameters
    case serverError
    case updateRequired
    case notFound
    case invalidToken
    case missingCredentials
    case noConnection
    case timeout
  }
  
  private init () {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 5 // seconds
    configuration.timeoutIntervalForResource = 5
    self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
  }
  
  
  private func deviceInfo() -> [String: String] {
    return [
      "Device-Type": "ios",
      "App-Version": (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "",
      "App-Build": (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    ]
  }
  
  
  private func parseError<T>(error: Error) -> Promise<T> {
    switch(error._code) {
    case(-1009):
      return Promise(error: ApiError.noConnection)
    case(-1001):
      return Promise(error: ApiError.timeout)
    default:
      break
    }
    
    if let alamoError = error as? AFError {
      switch (alamoError) {
      case .responseValidationFailed(let reason):
        switch(reason) {
        case .unacceptableStatusCode(401):
          return Promise(error: ApiError.invalidToken)
        case .unacceptableStatusCode(404):
          return Promise(error: ApiError.notFound)
        case .unacceptableStatusCode(422):
          return Promise(error: ApiError.missingParameters)
        case .unacceptableStatusCode(426):
          return Promise(error: ApiError.updateRequired)
        default:
          print("get alamo error \(error._code): \(error)")
          return Promise(error: ApiError.serverError)
        }
      default:
        break
      }
    }
    
    print("get error \(error._code): \(error)")
    
    return Promise(error: error)
  }
  


  
  
  /// makes request to server
  /// - parameter url: url
  /// - parameter method: method of request
  /// - parameter expectedCodes: any status code that server can return, if status code isn't provided then error is returned
  /// - parameter contentTypes: content type that server can return, if nill every type is allowed
  ///                           **default**: nil
  /// - parameter authenticationRequired: if true then api will try relogin if access token isn't
  ///                                     available. **defailt**: true
  /// - parameter retryLimit: indicates how many rettrys are allowed,
  ///                         **default**: ApiService.RETRY_LIMIT
  /// - parameter additionalHeaders: http headers that should be send to server.
  ///                                **default** [:]
  /// - parameter dataString: string returned from server
  /// - parameter statusCode: status code of response
  /// - throws APIError:
  func request<T>(
    url: String,
    method: HTTPMethod,
    parameters: [String: Any]?,
    expectedCodes: Set<Int>,
    contentTypes: Set<String>? = nil,
//    authenticationRequired: Bool = true,
    retryLimit: Int = ApiService.RETRY_LIMIT,
    additionalHeaders: [String: String] = [:],
    parser: @escaping (_ dataString: String, _ statusCode: Int) throws -> T
    ) -> Promise<T> {
    return _stringRequest(
      url: url,
      method: method,
      parameters: parameters,
      expectedCodes: expectedCodes,
      contentTypes: contentTypes,
//      authenticationRequired: authenticationRequired,
      retryLimit: retryLimit,
      additionalHeaders: additionalHeaders
      ).then {
        (result: (request: URLRequest, response: HTTPURLResponse, dataString: String)) throws -> T in
        return try parser(result.dataString, result.response.statusCode)
    }
  }
  
  
  private func _stringRequest(
    url: String,
    method: HTTPMethod,
    parameters: [String: Any]?,
    expectedCodes: Set<Int>,
    contentTypes: Set<String>?,
//    authenticationRequired: Bool,
    retryLimit: Int,
    error: Error? = nil,
    additionalHeaders: [String: String]
    ) -> Promise<(URLRequest, HTTPURLResponse, String)> {
    
    if retryLimit < 0 {
      let error: Error = error ?? ApiError.timeout
      return Promise<(URLRequest, HTTPURLResponse, String)>(error: error)
    }
    
    var dataRequest: DataRequest
    
    var headers: [String: String] = deviceInfo()
    
    for (key, val) in additionalHeaders {
      headers[key] = val
    }
    
    dataRequest = alamofireManager.request(
      url,
      method: method,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: headers
    )
    
  
    dataRequest = dataRequest
      .validate(statusCode: expectedCodes)
    
    if let contentTypes: Set<String> = contentTypes {
      dataRequest = dataRequest.validate(contentType: contentTypes)
    }
    
    
    
    return dataRequest
      .responseDataString()
      .recover(execute: parseError)
      .recover {
        (error: Error) -> Promise<(URLRequest, HTTPURLResponse, String)> in
        if let _: ApiError = error as? ApiError {
          return self._stringRequest(
            url: url,
            method: method,
            parameters: parameters,
            expectedCodes: expectedCodes,
            contentTypes: contentTypes,
            retryLimit: retryLimit - 1,
            additionalHeaders: additionalHeaders
          )
        }
        return Promise<(URLRequest, HTTPURLResponse, String)>(error: error)
    }
  }
}



fileprivate extension Alamofire.DataRequest {
  func responseDataString() -> Promise<(URLRequest, HTTPURLResponse, String)> {
    
    return Promise { fulfill, reject in
      responseString(queue: nil) { response in
        switch response.result {
        case .success(let value):
          if let request: URLRequest = response.request, let response: HTTPURLResponse = response.response {
            fulfill((request, response, value))
          } else {
            reject(PMKError.invalidCallingConvention)
          }
        case .failure(let error):
          reject(error)
        }
      }
    }
  }
}

