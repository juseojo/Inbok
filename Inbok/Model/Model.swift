//
//  Model.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation

class Help_model
{
    let page_name: String
    
    init(page_name: String = "당신은 누군가의 인복")
    {
        self.page_name = page_name
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
