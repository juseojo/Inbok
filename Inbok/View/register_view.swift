//
//  register_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/07/05.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

let host = "3.34.42.151:5001/"

class Register_view: UIView {
    
    var name_text: String? = Optional("none7")
    
    var name_field : UITextField = {
        var name_field = UITextField()
        
        name_field.backgroundColor = .systemGray2
        name_field.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)])
        name_field.layer.cornerRadius = 10
        name_field.addLeftPadding()
 
        return name_field
    }()

    var register_btn : UIButton = {
        var register_btn = UIButton()
        
        register_btn.setTitle("확인", for: .normal)
        register_btn.backgroundColor = UIColor(named: "InBok_color")
        register_btn.layer.cornerRadius = 10
        register_btn.titleLabel?.font = UIFont(name:"SeoulHangang", size: 20)
        register_btn.addTarget(self, action: #selector(register_btn_click(_:)), for: .touchUpInside)
        
        return register_btn
    }()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubview(name_field)
        addSubview(register_btn)
        

        self.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(screen_width)
            make.height.equalTo(screen_height)
        }
        
        name_field.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).inset(20)
            make.right.equalTo(self.snp.right).inset(20)

            make.height.equalTo(50)
        }
        
        register_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(name_field.snp.bottom).offset(20)
            make.centerX.equalTo(name_field)
            make.width.equalTo(name_field).dividedBy(2)
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }

    @objc func register_btn_click(_ sender : UIButton)
    {
        print("register button click\n")
        var vc = self.window?.rootViewController?.presentedViewController
        AF.request("http://\(host)/register", method: .post, parameters: ["name": name_field.text
, "oauth_key":UserDefaults.standard.string(forKey: "oauth_token")], encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: String] {
                    if (data["result"] == "success")
                    {
                        print("register success")
                        UserDefaults.standard.set(true, forKey: "launchBefore")
                        self.window?.rootViewController?.dismiss(animated: true)
                    }
                    else if ( data["result"] == "overlap" )
                    {
                        print("name overlap")
                        let alert = UIAlertController(title: "알림", message: "중복되는 닉네임입니다.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        vc?.present(alert, animated: false, completion: nil)
                    }
                    else if ( data["result"] == "kakao_overlap" )
                    {
                        print("kakao overlap")
                        let alert = UIAlertController(title: "알림", message: "이미 가입한 계정입니다.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        vc?.present(alert, animated: false, completion: nil)
                    }
                    else if ( data["result"] == "kakao_nil" )
                    {
                        print("kakao_nil")
                        let alert = UIAlertController(title: "알림", message: "카카오 계정 연동이 안되어 있습니다.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        vc?.present(alert, animated: false, completion: nil)
                    }
                    else if ( data["result"] == "name_nil" )
                    {
                        print("name_nil")
                        let alert = UIAlertController(title: "알림", message: " 이름을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        vc?.present(alert, animated: false, completion: nil)
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
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
