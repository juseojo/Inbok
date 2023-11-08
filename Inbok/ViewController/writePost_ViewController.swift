//
//  writePost_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/07/04.
//

import Foundation
import SwiftUI
import UIKit
import Alamofire

class writePost_ViewController: UIViewController {
    
    let writePost_view = WritePost_view()
    
    @objc func cancel_btn_click(_ sender : UIButton)
    {
        writePost_view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc func write_btn_click(_ sender : UIButton)
    {
        print("Write button click\n")
        let vc = writePost_view.window?.rootViewController?.presentedViewController
        
        if (writePost_view.title_field.text == Optional(""))
        {
            print("title nil")
            let alert = UIAlertController(title: "알림", message: "제목을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            vc?.present(alert, animated: false, completion: nil)
            
            return ;
        }
        else if (writePost_view.content_field.text == Optional(""))
        {
            print("content nil")
            let alert = UIAlertController(title: "알림", message: "내용을  입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            vc?.present(alert, animated: false, completion: nil)
            
            return ;
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        let paramaters = ["name": UserDefaults.standard.string(forKey: "name")!,
                          "title": writePost_view.title_field.text!,
                          "content": writePost_view.content_field.text!,
                          "time": formatter.string(from: date),
                          "profile_image": UserDefaults.standard.string(forKey: "profile_image") ?? "nil"] as [String : String]
        
        AF.request("http://\(host)/write", method: .post, parameters: paramaters, encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: String] {
                    if (data["result"] == "success")
                    {
                        print("write success")
                        self.writePost_view.window?.rootViewController?.dismiss(animated: true)
                    }
                    else
                    {
                        print("write fail")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        writePost_view.title_field.delegate = self
        writePost_view.content_field.delegate = self

        writePost_view.cancel_btn.addTarget(self, action: #selector(cancel_btn_click(_:)), for: .touchUpInside)
        
        writePost_view.write_btn.addTarget(self, action: #selector(write_btn_click(_:)), for: .touchUpInside)
        
        self.view.addSubview(writePost_view)

        view.backgroundColor = UIColor(named: "BACKGROUND")
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
