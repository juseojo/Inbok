//
//  register_viewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2023/09/07.
//

import Foundation
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKTalk
import UIKit

class Register_viewModel {
    
    let register_model: Register_model
    
    
    func use_name(name : String?)
    {
        register_model.name = name
    }
    
    func kakao_oauth()
    {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    exit(0)
                }
                else {
                    print("oauth save\n")
                    UserDefaults.standard.set(oauthToken?.idToken, forKey: "oauth_token")
                    print(UserDefaults.standard.object(forKey: "oauth_token"))
                    self.kakao_inform()
                }
            }
        }
    }

    func kakao_inform()
    {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                UserDefaults.standard.set(user?.id, forKey: "id")
                UserDefaults.standard.set(user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString, forKey: "profile_image")
                print("id save\n")
                print(user?.id ?? "id error\n")
                print("profile save\n")
                print(user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString)

            }
        }
    }
    func regist(register_vc : UIViewController)
    {
        //nil check
        if (UserDefaults.standard.string(forKey: "oauth_token") == nil)
        {
            print("kakao_nil")
            let alert = UIAlertController(title: "알림", message: "카카오 계정 연동이 안되어 있습니다.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            register_vc.present(alert, animated: false, completion: nil)
            
            return ;
        }
        else if(register_model.name == Optional(""))
        {
            print("name_nil")
            let alert = UIAlertController(title: "알림", message: " 이름을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            register_vc.present(alert, animated: false, completion: nil)
            
            return ;
        }
        
        //set data
        let parameters = ["name": register_model.name,
                          "oauth_key":UserDefaults.standard.string(forKey: "oauth_token"), "id" : UserDefaults.standard.string(forKey: "id"),
                          "profile_image" : UserDefaults.standard.string(forKey: "profile_image")
        ]
        
        //regist with server
        AF.request("http://\(host)/register", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: String] {
                    if (data["result"] == "success")
                    {
                        print("register success")
                        UserDefaults.standard.set(true, forKey: "launchBefore")
                        UserDefaults.standard.set(self.register_model.name, forKey: "name")

                        register_vc.dismiss(animated: true)
                    }
                    else if ( data["result"] == "overlap" )
                    {
                        print("name overlap")
                        let alert = UIAlertController(title: "알림", message: "중복되는 닉네임입니다.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        register_vc.present(alert, animated: false, completion: nil)
                    }
                    else if ( data["result"] == "kakao_overlap" )
                    {
                        print("kakao overlap")
                        let alert = UIAlertController(title: "알림", message: "이미 가입한 계정입니다. 원래 사용하던 닉네임을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        register_vc.present(alert, animated: false, completion: nil)
                    }
                    else if ( data["result"] == "id_overlap" )
                    {
                        print("id overlap")
                        let alert = UIAlertController(title: "알림", message: "이미 가입한 계정입니다. 원래 사용하던 닉네임을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        register_vc.present(alert, animated: false, completion: nil)
                    }
                    else if ( data["result"] == "login")
                    {
                        print("login success\n")
                        UserDefaults.standard.set(true, forKey: "launchBefore")
                        UserDefaults.standard.set(self.register_model.name, forKey: "name")

                        register_vc.presentingViewController?.dismiss(animated: true)
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
    
    init(model : Register_model){
        self.register_model = model
    }
}
