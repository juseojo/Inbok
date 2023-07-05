//
//  register_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/07/05.
//

import Foundation
import UIKit
import SnapKit

class Register_view: UIView {
    
    var container_view : UIView = {
        var container_view = UIView()
        
        return container_view
    }()
    
    var name_field : UITextField = {
        var name_field = UITextField()
        
        name_field.backgroundColor = .systemGray2
        name_field.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)])
        name_field.layer.cornerRadius = 10
        name_field.addLeftPadding()

        return name_field
    }()

    var register_btn : UIButton = {
        var register_btn = UIButton()
        
        register_btn.setTitle("확인", for: .normal)
        register_btn.backgroundColor = UIColor(named: "InBok_color")
        register_btn.layer.cornerRadius = 10
        register_btn.titleLabel?.font = UIFont(name:"SeoulHangang", size: 20)
        
        return register_btn
    }()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        container_view.addSubview(name_field)
        container_view.addSubview(register_btn)
        
        addSubview(container_view)

        container_view.snp.makeConstraints{ (make) in
            make.top.equalTo(self)
            make.width.equalTo(screen_width)
            make.height.equalTo(screen_height)
        }
        
        name_field.snp.makeConstraints{ (make) in
            make.centerY.equalTo(container_view.snp.centerY)
            make.left.equalTo(container_view.snp.left).inset(20)
            make.right.equalTo(container_view.snp.right).inset(20)

            make.height.equalTo(50)
        }
        
        register_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(name_field.snp.bottom).offset(20)
            make.centerX.equalTo(name_field)
            make.width.equalTo(name_field).dividedBy(2)
            make.height.equalTo(50)
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
