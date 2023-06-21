//
//  login_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/04.
//

import UIKit
import SnapKit
import KakaoSDKAuth
import KakaoSDKUser
import Alamofire
import SwiftUI

class register_ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = basic_backgroundColor(current_sysbackgroundColor: traitCollection.userInterfaceStyle)
        
        /*
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    exit(0)
                }
                else {
                    print("loginWithKakaoTalk() success.\n")
                    UserDefaults.standard.set(oauthToken?.idToken, forKey: "oauth_token")
                    UserDefaults.standard.set(true, forKey: "launchBefore")
                    print(UserDefaults.standard.object(forKey: "oauth_token"))
                    AF.request("http://54.180.127.51:5000/register").responseJSON() { response in
                        switch response.result {
                        case .success:
                            if let data = try! response.result.get() as? [String: Any] {
                                print(data)
                            }
                        case .failure(let error):
                                print("Error: \(error)")
                          }
                    }
                }
            }
        }
        else {
            print("kakao_login_error\n")
            exit(0)
        }
        */
        //여기에 닉네임 입력 받는 곳 만들어야함
        
        let name_field = UITextField()
        name_field.backgroundColor = .systemGray2
        name_field.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)])

        name_field.layer.cornerRadius = 10
        name_field.addLeftPadding()
        
        let register_btn = UIButton()
        register_btn.setTitle("확인", for: .normal)
        register_btn.backgroundColor = UIColor(named: "InBok_color")
        register_btn.layer.cornerRadius = 10
        register_btn.titleLabel?.font = UIFont(name:"SeoulHangang", size: 20)
        view.addSubview(name_field)
        view.addSubview(register_btn)
        
       name_field.snp.makeConstraints{ (make) in
           make.centerY.equalTo(view.snp.centerY)
           make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
           make.height.equalTo(50)
        }
        
        register_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(name_field.snp.bottom).offset(20)
            make.centerX.equalTo(name_field)
            make.width.equalTo(name_field).dividedBy(2)
            make.height.equalTo(50)
            
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

//for free view
 struct PreView_login: PreviewProvider {
     static var previews: some View {
         register_ViewController().toPreview_register()
     }
 }
 
 
 #if DEBUG
 extension UIViewController {
 private struct Preview: UIViewControllerRepresentable {
 let register_ViewController: UIViewController
 
 func makeUIViewController(context: Context) -> UIViewController {
 return register_ViewController
 }
 
 func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
 }
 }
 
 func toPreview_register() -> some View {
 Preview(register_ViewController: self)
 }
 }
 #endif
 //end preview

