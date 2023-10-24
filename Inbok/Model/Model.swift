//
//  Model.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation
import UIKit

let host = "43.201.57.229:5001/"

class Help_model
{
    var page_name: String
    var head_btn_image: UIImage
    
    var posts : [[String: String]]
    
    init(page_name: String, head_btn_image: UIImage)
    {
        self.posts = [[:]]
        self.page_name = page_name
        self.head_btn_image = head_btn_image
    }
}

class Register_model
{
    var name : String?
    init() {
        self.name = ""
    }
}


class Talk_model
{
    let page_name: String
    
    init(page_name: String = "대화 페이지")
    {
        self.page_name = page_name
    }
}
