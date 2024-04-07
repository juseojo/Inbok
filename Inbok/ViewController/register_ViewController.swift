//
//  login_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/04.
//

import UIKit
import SnapKit
import AuthenticationServices
import RealmSwift

class Register_ViewController: UIViewController {

	let register_view = Register_view()
	let register_viewModel = Register_viewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		register_view.name_field.delegate = self

		register_view.apple_login_btn.addTarget(self, action: #selector(apple_login_btn_click), for: .touchUpInside)
		register_view.kakao_login_btn.addTarget(self, action: #selector(kakao_login_btn_click), for: .touchUpInside)
		self.view.addSubview(register_view)

		view.backgroundColor = UIColor(named: "BACKGROUND")
		
	}

	@objc func kakao_login_btn_click(_ sender : UIButton)
	{
		print("kakao login button click\n")
		//test code
		if (self.register_view.name_field.text == test_account)
		{
			self.register_viewModel.use_name(name: self.register_view.name_field.text)
			UserDefaults.standard.set(true, forKey: "launchBefore")
			UserDefaults.standard.set(test_account, forKey: "name")
			get_user_inform(name: self.register_view.name_field.text ?? "none") { user_inform in
				UserDefaults.standard.set(user_inform["profile_image"], forKey: "profile_image")
			}
			self.dismiss(animated: false)
			return
		}
		//end test code

		self.register_viewModel.kakao_oauth() { isNewbie in
			if (isNewbie)
			{
				self.register_viewModel.use_name(name: self.register_view.name_field.text)
				self.register_viewModel.login(login_type: "kakao") { result in
					if (result == 0) //login success
					{
						get_user_inform(name: self.register_view.name_field.text ?? "none") { user_inform in
							UserDefaults.standard.set(user_inform["point"], forKey: "point")
						}
						self.dismiss(animated: false)
					}
					else
					{
						self.make_alert(index: result)
					}
				}
			}
			else
			{
				self.make_alert(index: 4)
			}
		}
	}
	
	func make_alert(index: Int)
	{
		switch index {
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
		case 4:
			let alert = UIAlertController(title: "알림", message: "이전 로그인과 다른 계정입니다.\n 로그인시 이전 대화 기록이 사라집니다.", preferredStyle: UIAlertController.Style.alert)
		
			alert.addAction(UIAlertAction(title: "로그인", style: .default) { action in
				self.register_viewModel.login(login_type: "kakao"){ result in
					if (result == 0)
					{
						let realm = try! Realm()
						do {
							try realm.write {
								realm.delete(realm.objects(Chat_DB.self))
							}
						} catch {
							print("realm error")
						}
						self.dismiss(animated: false)
					}
					else
					{
						self.make_alert(index: result)
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
