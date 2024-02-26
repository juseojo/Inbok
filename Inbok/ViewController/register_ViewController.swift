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
			self.register_viewModel.login(register_vc: self, login_type: "kakao")
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
		register_viewModel.login(register_vc: self, login_type: "apple")
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
