//
//  login_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/04.
//

import UIKit
import SnapKit

class register_ViewController: UIViewController {
    
    @objc func register_btn_click(_ sender : UIButton)
    {
        print("register button click\n")
        
        register_viewModel.use_name(name: register_view.name_field.text)
        register_viewModel.regist(register_vc: self)
    }
    
    let register_view = Register_view()
    var register_model = Register_model()
    lazy var register_viewModel = Register_viewModel(model: register_model)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        register_view.register_btn.addTarget(self, action: #selector(register_btn_click(_:)), for: .touchUpInside)
                
        register_view.name_field.delegate = self

        self.view.addSubview(register_view)

        view.backgroundColor = basic_backgroundColor(current_sysbackgroundColor: traitCollection.userInterfaceStyle)
        
        register_viewModel.kakao_oauth()
    }
}

extension register_ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
}
