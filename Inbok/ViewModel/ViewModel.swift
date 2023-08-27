//
//  ViewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import UIKit

class Help_viewModel {
    let help_model: Help_model
    
    init(help_model:Help_model){
        self.help_model = help_model
    }
    
    var head_text: String {
        return help_model.page_name
    }
    
    var head_btn_image: UIImage{
        return help_model.head_btn_image
    }
}

class Talk_viewModel {
    let talk_model: Talk_model
    
    init(){
        self.talk_model = Talk_model()
    }
    
    var head_text: String {
        return talk_model.page_name
    }
}

class Register_viewModel {
    let register_model: Register_model
    
    init(register_model: Register_model){
        self.register_model = register_model
    }
}

extension Help_viewModel {
    func configure(_ view: Help_view) {
        view.head_label.text = head_text
        view.head_btn.setImage(head_btn_image, for: .normal)
    }
}

extension Register_viewModel {
    func configure(_ view: Register_view) {
    }
}

extension Talk_viewModel {
    func configure(_ view: Talk_view) {
        view.head_label.text = head_text
    }
}
