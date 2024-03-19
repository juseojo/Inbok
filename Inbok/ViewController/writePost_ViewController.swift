//
//  writePost_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/07/04.
//

import Foundation
import SwiftUI
import UIKit
import Alamofire

class WritePost_ViewController: UIViewController {

    let writePost_view = WritePost_view()
	var point = 1
	var keyboard_rectangle = CGRect(x: 0, y: 0, width: 0, height: 0)

    @objc func back_btn_click(_ sender : UIButton)
    {
		self.navigationController?.popViewController(animated:true)
		self.tabBarController?.tabBar.isHidden = false
    }
	
	@objc func point_up_btn_click(_ sender : UIButton)
	{
		if (point == 5)
		{
			let alert = UIAlertController(title: "알림", message: "5 포인트가 최대 포인트입니다.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "확인", style: .default, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: false, completion: nil)
		}
		else
		{
			point += 1
			writePost_view.point_label.text = ": " + String(point)
		}
	}

	@objc func point_down_btn_click(_ sender : UIButton)
	{
		if (point == 1)
		{
			let alert = UIAlertController(title: "알림", message: "1 포인트가 최소 포인트입니다.", preferredStyle: UIAlertController.Style.alert)
			let action = UIAlertAction(title: "확인", style: .default, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: false, completion: nil)
		}
		else
		{
			point -= 1
			writePost_view.point_label.text = ": " + String(point)
		}
	}
    
    @objc func write_btn_click(_ sender : UIButton)
    {
        print("Write button click")
        let vc = writePost_view.window?.rootViewController?.presentedViewController
        
        if (writePost_view.title_field.text == Optional(""))
        {
            print("title nil")
            let alert = UIAlertController(title: "알림", message: "제목을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            vc?.present(alert, animated: false, completion: nil)
            
            return ;
        }
        else if (writePost_view.content_text_view.text == Optional(""))
        {
            print("content nil")
            let alert = UIAlertController(title: "알림", message: "내용을  입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            vc?.present(alert, animated: false, completion: nil)
            
            return ;
        }

        let paramaters = ["name": UserDefaults.standard.string(forKey: "name") ?? "none",
                          "title": writePost_view.title_field.text!,
                          "content": writePost_view.content_text_view.text!,
						  "time": date_formatter.string(from: Date()),
                          "profile_image": UserDefaults.standard.string(forKey: "profile_image") ?? "none",
						  "point": String(point)
						] as [String : String]

        AF.request("http://\(host)/write", method: .post, parameters: paramaters, encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: String] {
                    if (data["result"] == "success")
					{
						print("write success")
						let user_point = UserDefaults.standard.integer(forKey: "point")
						UserDefaults.standard.setValue(user_point - self.point, forKey: "point")
						self.navigationController?.popViewController(animated:true)
						self.tabBarController?.tabBar.isHidden = false
					}
					else if (data["result"] == "need_point")
					{
						print("need more point")
						let alert = UIAlertController(title: "알림", message: "포인트가 모자랍니다. 현재 소유 포인트: \(data["point"] ?? "none")", preferredStyle: UIAlertController.Style.alert)
						let action = UIAlertAction(title: "확인", style: .default, handler: nil)
						alert.addAction(action)
						self.present(alert, animated: false, completion: nil)
					}
                    else
                    {
                        print("write fail")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        writePost_view.title_field.delegate = self
        writePost_view.content_text_view.delegate = self
		
		self.tabBarController?.tabBar.isHidden = true
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			self.writePost_view.title_field.becomeFirstResponder()
		}
		writePost_view.back_btn.addTarget(self, action: #selector(back_btn_click(_:)), for: .touchUpInside)
        writePost_view.write_btn.addTarget(self, action: #selector(write_btn_click(_:)), for: .touchUpInside)
		writePost_view.point_up_btn.addTarget(self, action: #selector(point_up_btn_click(_:)), for: .touchUpInside)
		writePost_view.point_down_btn.addTarget(self, action: #selector(point_down_btn_click(_:)), for: .touchUpInside)
        
        self.view.addSubview(writePost_view)

        view.backgroundColor = UIColor(named: "BACKGROUND")
    }

	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
	}
	
	@objc func keyboardUp(notification:NSNotification) {
		if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			keyboard_rectangle = keyboardFrame.cgRectValue
			writePost_view.title_field.resignFirstResponder()
			NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		}
	}
}

extension WritePost_ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
		}
        
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		return true
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return true
	}
}

extension WritePost_ViewController: UITextViewDelegate {

	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		
		if (textView.textColor == .white)
		{
			textView.textColor = .label
			textView.text = nil
		}
		self.writePost_view.bottom_view.snp.updateConstraints{ (make) in
			make.bottom.equalTo(self.writePost_view).inset(10 + keyboard_rectangle.height)
		}

		UIView.animate(
			withDuration: 0.2
			, animations: self.writePost_view.layoutIfNeeded
		)
		return true
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		self.writePost_view.bottom_view.snp.updateConstraints{ (make) in
			make.bottom.equalTo(self.writePost_view).inset(bottom_inset)
		}

		UIView.animate(
			withDuration: 0.2
			, animations: self.writePost_view.layoutIfNeeded
		)
		
		return true
	}
}
