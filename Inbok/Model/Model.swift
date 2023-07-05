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
    var head_btn_image: UIImage
    
    init(page_name: String, head_btn_image: UIImage)
    {
        self.page_name = page_name
        self.head_btn_image = head_btn_image
    }
}

class Register_model
{
    var name_field: UITextField
    var register_btn: UIButton
    
    init(_ name_field: UITextField,_ register_btn: UIButton) {
        self.name_field = name_field
        self.register_btn = register_btn
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
