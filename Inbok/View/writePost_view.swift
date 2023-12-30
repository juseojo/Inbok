//
//  writePost_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/08/28.
//

import Foundation
import UIKit
import SnapKit


class WritePost_view: UIView {
    
    var title_field : UITextField = {
        var title_field = UITextField()
        
        title_field.backgroundColor = .systemGray2
        title_field.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name:"SeoulHangang", size: 20)!])
        title_field.layer.cornerRadius = 10
        title_field.addLeftPadding()
 
        return title_field
    }()
    
    var content_text_view : UITextView = {
        var content_text_view = UITextView()
        
		content_text_view.backgroundColor = .systemGray2
		content_text_view.layer.cornerRadius = 10

        return content_text_view
    }()
    
    var write_btn : UIButton = {
        var write_btn = UIButton()
        
        write_btn.setTitle("확인", for: .normal)
        write_btn.backgroundColor = UIColor(named: "InBok_color")
        write_btn.layer.cornerRadius = 10
        write_btn.titleLabel?.font = UIFont(name:"SeoulHangang", size: 20)
        
        return write_btn
    }()
    
    var cancel_btn : UIButton = {
        var cancel_btn = UIButton()
        
        cancel_btn.setTitle("취소", for: .normal)
        cancel_btn.backgroundColor = UIColor(named: "InBok_color")
        cancel_btn.layer.cornerRadius = 10
        cancel_btn.titleLabel?.font = UIFont(name:"SeoulHangang", size: 20)
        
        return cancel_btn
    }()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(title_field)
        addSubview(content_text_view)
        addSubview(write_btn)
        addSubview(cancel_btn)
        
        self.snp.makeConstraints{ (make) in
            make.top.equalTo(self)
            make.height.equalTo(screen_height)
            make.width.equalTo(screen_width)
        }
        title_field.snp.makeConstraints{ (make) in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalTo(self).inset(10)
            make.height.equalTo(screen_height * 0.1)
        }
        write_btn.snp.makeConstraints{ (make) in
            make.height.equalTo(screen_height * 0.1)
            make.left.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.right.equalTo(self.snp.centerX)
                .offset(-10)
        }
        cancel_btn.snp.makeConstraints{ (make) in
            make.height.equalTo(screen_height * 0.1)
            make.right.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.left.equalTo(self.snp.centerX)
                .offset(10)
        }
		content_text_view.snp.makeConstraints{ (make) in
            make.top.equalTo(title_field.snp.bottom).inset(-10)
            make.left.right.equalTo(self).inset(10)
            make.bottom.equalTo(write_btn.snp.top).inset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
