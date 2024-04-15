//
//  register_viewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2023/09/07.
//

import UIKit

import Alamofire
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKTalk

class Register_viewModel {
    
    let register_model = Register_model()
	
    func use_name(name : String?)
    {
        register_model.name = name
    }
    
	func kakao_oauth(closure_1st: @escaping (Bool) -> Void)
    {
        if (UserApi.isKakaoTalkLoginAvailable())
		{
			UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
				if let error = error {
					print(error)
					exit(0)
				}
				else {
					self.kakao_inform() { isNewbie in
						closure_1st(isNewbie)
					}
				}
			}
		}
		else
		{
			print("kakao_login_fail")
		}
    }

	func kakao_inform(closure_2nd: @escaping (Bool) -> Void)
    {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
				if (UserDefaults.standard.string(forKey: "id")?.isEmpty != nil)
				{
					if (String((user?.id)!) != UserDefaults.standard.string(forKey: "id"))
					{
						closure_2nd(false)
					}
				}
                UserDefaults.standard.set(user?.id, forKey: "id")
                UserDefaults.standard.set(user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString, forKey: "profile_image")
				print("id save\n")
                print(user?.id ?? "id error\n")
				print("profile save\n")
                print(user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString)
				closure_2nd(true)
            }
        }
    }
	
	func apple_login()
	{
		
	}
	
	
	func login(login_type: String, closure: @escaping (Int) -> Void)
	{
		print("try login")

		if (self.register_model.name == Optional(""))
		{
			print("name_nil")
			
			closure(1)
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
						closure(0)
					}
					else if (data["result"] == "wrong_name")
					{
						print("wrong name")

						closure(2)
					}
					else if (data["result"] == "fail")
					{
						print("login fail")

						closure(3)
					}
					else
					{
						closure(-1)
					}
				}
				
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}
	
    func regist(closure: @escaping ((UIAlertController), (Bool)) -> Void)
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
						UserDefaults.standard.set(3, forKey: "point")
                        UserDefaults.standard.set(self.register_model.name, forKey: "name")
						let alert = UIAlertController()

                        closure(alert, true)
                    }
                    else if ( data["result"] == "kakao_overlap" )
					{
						print("kakap overlap")
						
						let alert = UIAlertController(title: "알림", message: "이미 카카오로 가입된 계정입니다.", preferredStyle: UIAlertController.Style.alert)
						let action = UIAlertAction(title: "확인", style: .default, handler: nil)
						
						alert.addAction(action)
						closure(alert, false)
					}
                    else if ( data["result"] == "apple_overlap" )
					{
						print("apple overlap")
						
						let alert = UIAlertController(title: "알림", message: "이미  애플로 가입된 계정입니다.", preferredStyle: UIAlertController.Style.alert)
						let action = UIAlertAction(title: "확인", style: .default, handler: nil)
						
						alert.addAction(action)
						closure(alert, false)
					}
					else if ( data["result"] == "name_overlap" )
					{
						print("name overlap")
						
						let alert = UIAlertController(title: "알림", message: "중복된 이름입니다.", preferredStyle: UIAlertController.Style.alert)
						let action = UIAlertAction(title: "확인", style: .default, handler: nil)
						
						alert.addAction(action)
						closure(alert, false)
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
