//
//  Model.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation
import UIKit

class Help_model
{
    var page_name: String
    
    var posts : [[String: String]]
    //"name" : post[0] , "title": post[1] , "content": post[2] , "time": post[3] , "profile_image:  post[4]"
    
    init(page_name: String)
    {
        self.posts = [[:]]
        self.page_name = page_name
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

}
