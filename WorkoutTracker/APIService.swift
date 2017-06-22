//
//  APIService.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/7/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private var POST_URL = "http://104.236.21.144:3001/"
    
    func post(endpoint url: String, data json: [String: AnyObject], completion handler: ([String: AnyObject]) -> Void) {
        var request = URLRequest(url: URL(string: POST_URL + url)!)
        request.httpMethod = "POST"
        //send email / ex id etc
        let postString = "exerciseKey=\(json["exerciseKey"] as! String)&opponentEmail=\(json["opponent"] as! String)&userID=\(DBService.shared.user.uid)&userEmail=\(DBService.shared.user.email!)"
        request.httpBody = postString.data(using: .utf8)
        print(postString)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(response as Any)
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        
    }
    
//    func get(endpoint url: String, data json: [String: AnyObject], completion handler: ([String: AnyObject]) -> Void) {
//        
//    }
}
