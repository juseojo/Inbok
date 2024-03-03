//
//  login_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/04.
//

import UIKit
import SnapKit
import AuthenticationServices

class Register_ViewController: UIViewController {

	let register_view = Register_view()
	var register_model = Register_model()
	lazy var register_viewModel = Register_viewModel(model: register_model)
	
	
	@objc func kakao_login_btn_click(_ sender : UIButton)
	{
		print("kakao login button click\n")
	
		self.register_viewModel.kakao_oauth()
		{
			self.register_viewModel.use_name(name: self.register_view.name_field.text)
			self.register_viewModel.login(login_type: "kakao") { result in
				if (result == 0)
				{
					self.dismiss(animated: false)
				}
				else 
				{
					self.make_alert(index: result)
				}
			}
		}
	}
	
	func make_alert(index: Int)
	{
		switch index {
		case 0:
			print("login")
		case 1:
			let alert = UIAlertController(title: "알림", message: "닉네임을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "확인", style: .default, handler: nil)

			alert.addAction(action)
			self.present(alert, animated: false)
		case 2:
			let alert = UIAlertController(title: "알림", message: "잘못된 닉네임입니다.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "확인", style: .default, handler: nil)

			alert.addAction(action)
			self.present(alert, animated: false)
		case 3:
			let alert = UIAlertController(title: "알림", message: "로그인에 실패하였습니다.\n 해당 정보로 가입하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
			
			alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
				self.register_viewModel.regist() { alert, isRegist in
					if (isRegist)
					{
						self.dismiss(animated: false)
					}
					else
					{
						self.present(alert, animated: false, completion: nil)
					}
				}
			})
			alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
			self.present(alert, animated: false)
		default:
			print("make_alert error")
		}
	}
	
	@objc func apple_login_btn_click(_ sender : UIButton)
	{
		print("apple login button click\n")

		let request = ASAuthorizationAppleIDProvider().createRequest()
		
		request.requestedScopes = [.email]
		
		let controller = ASAuthorizationController(authorizationRequests: [request])
		controller.delegate = self
		controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
		controller.performRequests()

		print("test")
		register_viewModel.use_name(name: register_view.name_field.text)
		register_viewModel.login(login_type: "apple") { result in
			if (result == 0)
			{
				self.dismiss(animated: false)
			}
			else 
			{
				self.make_alert(index: result)
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        register_view.name_field.delegate = self

		register_view.apple_login_btn.addTarget(self, action: #selector(apple_login_btn_click), for: .touchUpInside)
		register_view.kakao_login_btn.addTarget(self, action: #selector(kakao_login_btn_click), for: .touchUpInside)
        self.view.addSubview(register_view)

        view.backgroundColor = UIColor(named: "BACKGROUND")
        
    }
}

extension Register_ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
}

extension Register_ViewController: ASAuthorizationControllerDelegate {
	func authorizationController(
		controller: ASAuthorizationController,
		didCompleteWithAuthorization auth: ASAuthorization)
	{
		guard let credential = auth.credential as? ASAuthorizationAppleIDCredential
		else { return }

		if let email = credential.email
		{
			print("apple login success")
			print("이메일 : \(email)")
			
		}
		else 
		{
			print("Not first login")
		}
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		
		print(error)
	}
}
