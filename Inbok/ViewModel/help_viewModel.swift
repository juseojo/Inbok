//
//  help_viewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2023/09/07.
//

import Foundation
import UIKit

class Help_viewModel {
    
    init(help_model:Help_model){
        self.help_model = help_model
    }
    
    let help_model: Help_model
    
    var head_text: String {
        return help_model.page_name
    }
    
    var head_btn_image: UIImage{
        return help_model.head_btn_image
    }
    
    func login(help_vc : UIViewController,root_vc : UIViewController)
    {
        if UserDefaults.standard.bool(forKey: "launchBefore") == false
        {
            print("\nRun first\n")
            help_vc.present(root_vc, animated: false)
        }
        else if UserDefaults.standard.object(forKey: "oauth_token") == nil
        {
            print("\nNot first run but oauth not found\n")
            help_vc.present(root_vc, animated: false)
        }
        else if UserDefaults.standard.string(forKey: "name") == nil
        {
            print("pass oauth but regist not success by name\n")
            help_vc.present(root_vc, animated: false)
        }
        else
        {
            print("\nNomal login\n\n")
            print(UserDefaults.standard.object(forKey: "oauth_token") ?? "nil")
            
            //for test code
            UserDefaults.standard.set(nil, forKey: "oauth_token")
            UserDefaults.standard.set(nil, forKey: "id")
            UserDefaults.standard.set(false, forKey: "launchBefore")
            //it must be delete
        }
    }
}

extension Help_viewModel {
    func configure(_ view: Help_view) {
        view.head_label.text = head_text
        view.head_btn.setImage(head_btn_image, for: .normal)
    }
}
