//
//  util.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/19.
//

import Foundation
import UIKit


let host = "43.201.57.229:5001/"
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
