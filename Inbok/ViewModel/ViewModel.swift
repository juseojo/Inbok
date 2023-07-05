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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        name_text = textField.text
    }
    
    @objc func register_btn_click(_ sender : UIButton )
    {
        AF.request("http://\(host)/register", method: .post, parameters: ["name":name_text, "oauth_key":UserDefaults.standard.string(forKey: "oauth_token")], encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: String] {
                    if (data["result"] == "success")
                    {
                        print("register success")
                        //.dismiss(animated: true)
                    }
                    else if ( data["result"] == "overlap" )
                    {
                        print("name overlap")
                        let alert = UIAlertController(title: "알림", message: "중복되는 닉네임입니다.", preferredStyle: UIAlertController.Style.alert)
                    }
                    else
                    {
                        print("register fail")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    var name_text: String?
    var name_field: UITextField
    var register_btn: UIButton
    
    init(register_model: Register_model){
        self.register_model = register_model
        self.name_field = register_model.name_field
        self.register_btn = register_model.register_btn
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
        register_btn.addTarget(self, action: #selector(register_btn_click(_:)), for: .touchUpInside)
        name_field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
    }
}

extension Talk_viewModel {
    func configure(_ view: Talk_view) {
        view.head_label.text = head_text
    }
}
