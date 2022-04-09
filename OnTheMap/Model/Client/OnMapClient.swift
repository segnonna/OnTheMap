//
//  OnMapClient.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation

class OnMapClient {
    
    struct Sessions {
        static var sessionId: String = ""
        static var uniqueId: String = ""
        static let firstName: String = "Yoann"
        static let lastName: String = "Rodriguez"
        static var latitude: Double = 0.0
        static var longitude: Double = 0.0
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case login
        
        case studentLocation(String?)
        
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
                
            case .studentLocation(let param): if param == nil {
              return  Endpoints.base + "StudentLocation"
            }else {
              return   Endpoints.base + "StudentLocation" + param!
            }
                
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    

    class func fetchStudentsLocations(completion: @escaping ([StudentsLocationsResponse.StudentLocation], Error?) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoints.studentLocation("?order=-updatedAt&limmit=100").url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentsLocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    class func addOrUpdateMyPosition(mediaURL:String, latitude:Double, longitude:Double, mapString:String,  completion: @escaping (Bool, String?) -> Void){
        let body = MyLocationRequest(uniqueKey: Sessions.uniqueId, firstName: Sessions.firstName, lastName: Sessions.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.studentLocation(nil).url, stripResponse: false, responseType: MyLocationResponse.self, body: body) { response, error in
            if let response = response {
                Sessions.uniqueId = response.objectId
                completion(true, error?.localizedDescription)
            } else {
                completion(false, error?.localizedDescription)
            }
        }
    }
    
    class func login(username:String, password:String, completion: @escaping (Bool, String?) -> Void){
        let body = LoginRequest(udacity: LoginRequest.Credentials(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.login.url, stripResponse: true,  responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                print(response)
                Sessions.sessionId = response.session.id
                Sessions.uniqueId = response.account.key
                completion(true, error?.localizedDescription)
            } else {
                completion(false, error?.localizedDescription)
            }
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, stripResponse: Bool,  responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        if Sessions.latitude.isZero { request.httpMethod = "POST" } else { request.httpMethod = "PUT" }
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            var newData: Data
            if stripResponse {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }else{
                newData = data
            }
            
            print(String(data: newData, encoding: .utf8)!)
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                
                do {
                    let errorResponse = try decoder.decode(MapResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func deleteSession(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              DispatchQueue.main.async {completion(false, error)}
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
          print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async { completion(true, nil)}
        }
        task.resume()
    }
    
}
