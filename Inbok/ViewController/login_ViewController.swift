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

class login_ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        //여기에 닉네임 입력 받는 곳 만들어야함
        let name_label = UILabel()
        name_label.text = "닉네임을 입력해주세요."
        let name_field = UITextField()
        
        view.addSubview(name_label)
        view.addSubview(name_field)
        name_label.snp.makeConstraints{ (make) in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
       name_field.snp.makeConstraints{ (make) in
           make.top.equalTo(name_label.snp.bottom)
           make.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
           make.height.equalTo(200)
        }
    }
}

//for free view
 struct PreView_login: PreviewProvider {
     static var previews: some View {
         login_ViewController().toPreview_login()
     }
 }
 
 
 #if DEBUG
 extension UIViewController {
 private struct Preview: UIViewControllerRepresentable {
 let login_ViewController: UIViewController
 
 func makeUIViewController(context: Context) -> UIViewController {
 return login_ViewController
 }
 
 func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
 }
 }
 
 func toPreview_login() -> some View {
 Preview(login_ViewController: self)
 }
 }
 #endif
 //end preview

