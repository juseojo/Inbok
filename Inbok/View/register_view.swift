//
//  register_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/07/05.
//

import UIKit

import SnapKit
import Alamofire

class Register_view: UIView {
        
    var name_field : UITextField = {
        var name_field = UITextField()
        
        name_field.backgroundColor = .systemGray2
        name_field.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)])
        name_field.layer.cornerRadius = 12
        name_field.addLeftPadding()
 
        return name_field
    }()

	var kakao_login_btn: UIButton = {
		var kakao_login_btn = UIButton()

		kakao_login_btn.layer.cornerRadius = 12
		kakao_login_btn.setImage(UIImage(named: "kakao_login_large_wide.png"), for: .normal)

		return kakao_login_btn
	}()
	
	var apple_login_btn: UIButton = {
		
		var apple_login_btn = UIButton()
		
		apple_login_btn.setImage(UIImage(named: "APPLE_LOGIN_BTN"), for: .normal)
		
		return apple_login_btn
	}()
	
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubview(name_field)
        addSubview(kakao_login_btn)
        addSubview(apple_login_btn)

        self.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(screen_width)
            make.height.equalTo(screen_height)
        }
        
        name_field.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.snp.centerY)
			make.left.right.equalTo(self).inset(20)
            make.height.equalTo(50)
        }
        
        kakao_login_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(name_field.snp.bottom).offset(50)
			make.left.right.height.equalTo(name_field)
        }
		
		apple_login_btn.snp.makeConstraints{ (make) in
			make.top.equalTo(kakao_login_btn.snp.bottom).offset(20)
			make.left.right.height.equalTo(name_field)
		}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
