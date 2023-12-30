//
//  util.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/19.
//

import Foundation
import UIKit
import Alamofire

let host = "43.202.245.98:5001/"
let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let head_height: CGFloat = screen_height * 0.05

let date = Date()
let date_formatter :DateFormatter = {
    
    let date_formatter = DateFormatter()
    
    date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    date_formatter.locale = Locale(identifier: "ko_kr")
    date_formatter.timeZone = TimeZone(abbreviation: "KST")
    
    return date_formatter
}()

func time_diff(past_date:Date) -> Int
{
    let now_date = Date()
    let diff = Int(now_date.timeIntervalSince(past_date))/60
    
    return diff
}

func get_user_inform(name : String) -> [String : String]
{
    var result: [String : String] = [:]
    
    AF.request(host,
               method: .get,
               parameters: ["name" :name],
               encoding: URLEncoding.default,
               headers: ["Content-Type":"application/json", "Accept":"application/json"])
    .validate(statusCode: 200..<300)
    .responseJSON { response in
        switch response.result {
        case .success(let data):
            result = data as! [String : String]
        case .failure(let error):
            print(error)
        }
    }
    
    return result
}

extension [[String:String]] {
    mutating func delete_firstNil()
    {
        if (!self.isEmpty)
        {
            if (self[0].isEmpty)
            {
                self.remove(at: 0)
            }
        }
    }
}
