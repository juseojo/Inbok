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
import KakaoSDKTalk
import SwiftUI

class register_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let register_view = Register_view()
        let register_model = Register_model()
        var register_viewModel = Register_viewModel(register_model: register_model)
        
        register_view.name_field.delegate = self
        
        register_viewModel.configure(register_view)
        self.view.addSubview(register_view)

        view.backgroundColor = basic_backgroundColor(current_sysbackgroundColor: traitCollection.userInterfaceStyle)
        
        kakao_oauth()
    }
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
                kakao_inform()
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


extension register_ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
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

