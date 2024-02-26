//
//  register_viewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2023/09/07.
//

import Foundation

import Alamofire
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKTalk
import UIKit

class Register_viewModel {
    
    let register_model: Register_model
    
    
    func use_name(name : String?)
    {
        register_model.name = name
    }
    
	func kakao_oauth(closure: @escaping () -> Void)
    {
        if (UserApi.isKakaoTalkLoginAvailable())
		{
			UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
				if let error = error {
					print(error)
					exit(0)
				}
				else {
					print(oauthToken)
					self.kakao_inform()
					{
						closure()
					}
				}
			}
		}
		else
		{
			print("kakao_login_fail")
		}
    }

	func kakao_inform(closure: @escaping () -> Void)
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
				closure()
            }
        }
    }
	
	func apple_login()
	{
		
	}
	
	
	func login(register_vc : UIViewController, login_type: String)
	{
		print("try login")
		//nil check
		/*
		if (login_type == "kakao" && UserDefaults.standard.string(forKey: "id") == nil)
		{
			print("kakao_nil")
			let alert = UIAlertController(title: "알림", message: "카카오 계정 연동이 안되어 있습니다.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "확인", style: .default, handler: nil)
			alert.addAction(action)
			register_vc.present(alert, animated: false, completion: nil)
			
			return ;
		}
		else if (login_type == "apple" && UserDefaults.standard.string(forKey: "mail") == nil)
		{
			print("apple_nil")
			let alert = UIAlertController(title: "알림", message: "애플 계정 연동이 안되어 있습니다.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "확인", style: .default, handler: nil)
			alert.addAction(action)
			register_vc.present(alert, animated: false, completion: nil)
			
			return ;
		}*/
		if (self.register_model.name == Optional(""))
		{
			print("name_nil")
			let alert = UIAlertController(title: "알림", message: "닉네임을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "확인", style: .default, handler: nil)

			alert.addAction(action)
			register_vc.present(alert, animated: false, completion: nil)
			
			return ;
		}

		let parameters =
		[
			"name": register_model.name ?? "none",
			"id" : UserDefaults.standard.string(forKey: "id") ?? "none",
			"mail" : UserDefaults.standard.string(forKey: "mail") ?? "none",
			"login_type" : login_type
		]
		
		AF.request("http://\(host)/login", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON() { response in
			switch response.result {
			case .success:
				if let data = try! response.result.get() as? [String: String] {
					if (data["result"] == "login")
					{
						print("login success")
						
						UserDefaults.standard.set(true, forKey: "launchBefore")
						UserDefaults.standard.set(self.register_model.name, forKey: "name")

						register_vc.dismiss(animated: true)
					}
					else if (data["result"] == "wrong name")
					{
						print("wrong name")

						let alert = UIAlertController(title: "알림",
													  message: "잘못된 닉네임입니다.",
													  preferredStyle: UIAlertController.Style.alert)
						let action = UIAlertAction(title: "확인",
												   style: .default,
												   handler: nil)
						
						alert.addAction(action)
						register_vc.present(alert, animated: false, completion: nil)
					}
					else if (data["result"] == "fail")
					{
						print("login fail")

						let alert = UIAlertController(title: "알림",
													  message: "로그인에 실패하였습니다.\n 해당 정보로 가입하시겠습니까?",
													  preferredStyle: UIAlertController.Style.alert)
						alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
							self.regist(register_vc: register_vc)
						})
						alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
						register_vc.present(alert, animated: false, completion: nil)
					}
				}
				
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}
	
    func regist(register_vc : UIViewController)
    {
        //set data
        let parameters = 
		[
			"name": register_model.name ?? "none",
			"id" : UserDefaults.standard.string(forKey: "id") ?? "none",
			"profile_image" : UserDefaults.standard.string(forKey: "profile_image") ?? "none",
			"mail" : UserDefaults.standard.string(forKey: "mail") ?? "none"
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
                    else if ( data["result"] == "kakao_overlap" )
                    {
                        print("kakap overlap")

                        let alert = UIAlertController(title: "알림", message: "이미 카카오로 가입된 계정입니다.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)

                        alert.addAction(action)
                        register_vc.present(alert, animated: false, completion: nil)
                    }
                    else if ( data["result"] == "apple_overlap" )
                    {
                        print("apple overlap")

                        let alert = UIAlertController(title: "알림", message: "이미  애플로 가입된 계정입니다.", preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)

                        alert.addAction(action)
                        register_vc.present(alert, animated: false, completion: nil)
                    }
					else if ( data["result"] == "name_overlap" )
					{
						print("name overlap")

						let alert = UIAlertController(title: "알림", message: "중복된 이름입니다.", preferredStyle: UIAlertController.Style.alert)
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
