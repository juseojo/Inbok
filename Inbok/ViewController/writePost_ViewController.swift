//
//  writePost_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/07/04.
//

import Foundation
import SwiftUI
import UIKit

class writePost_ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let writePost_view = WritePost_view()
        writePost_view.title_field.delegate = self
        writePost_view.content_field.delegate = self

        self.view.addSubview(writePost_view)

        view.backgroundColor = basic_backgroundColor(current_sysbackgroundColor: traitCollection.userInterfaceStyle)
    }
}

extension writePost_ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
}
