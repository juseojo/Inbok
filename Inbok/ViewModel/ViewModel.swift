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

class Talk_viewModel {
    let talk_model: Talk_model
    
    init(){
        self.talk_model = Talk_model()
    }
    
    var head_text: String {
        return talk_model.page_name
    }
}

extension Talk_viewModel {
    func configure(_ view: Talk_view) {
        view.head_label.text = head_text
    }
}
