//
//  chat_view.swift
//  Inbok
//
//  Created by seongjun cho on 12/6/23.
//

import Foundation
import UIKit
import SnapKit

class Chat_view : UIView {

	let head_view: UIView = {
		let head_view = UIView()
		
		let line: CALayer = CALayer()

		line.frame = CGRect(x: 0, y: head_height - 0.2, width: screen_width, height: 0.2)
		line.backgroundColor = UIColor.gray.cgColor
		head_view.layer.addSublayer(line)
		
		return head_view
	}()
	
	let back_btn: UIButton = {
		let back_btn = UIButton()
		
		back_btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
		back_btn.tintColor = UIColor.gray
		
		return back_btn
	}()
    
	let chat_bar_view: UIView = {
		let chat_bar_view = UIView()
				
		return chat_bar_view
	}()
	
	let chat_text_view: UITextView = {
		let chat_text_view = UITextView()

		chat_text_view.backgroundColor = .systemGray3
		chat_text_view.layer.cornerRadius = 10
		chat_text_view.font = UIFont(name:"SeoulHangang", size: 25)
		return chat_text_view
	}()
	
	let chat_send_button: UIButton = {
		let chat_send_button = UIButton()
		
		let image_config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
		chat_send_button.tintColor = UIColor(named: "InBok_color")
		chat_send_button.setImage(UIImage(systemName: "paperplane.circle", withConfiguration: image_config), for: .normal)
		
		return chat_send_button
	}()
	
    override init(frame: CGRect) {
        super.init(frame: frame)

		addSubview(head_view)
		head_view.addSubview(back_btn)
		
		addSubview(chat_bar_view)
		chat_bar_view.addSubview(chat_text_view)
		chat_bar_view.addSubview(chat_send_button)
		
		head_view.snp.makeConstraints{ (make) in
			make.top.equalTo(self.snp.top)
			make.width.equalTo(self.snp.width)
			make.height.equalTo(head_height)
		}

		back_btn.snp.makeConstraints{ (make) in
			make.top.equalTo(head_view).inset(3)
			make.left.equalTo(head_view).inset(15)
			make.bottom.equalTo(head_view).inset(3)
		}
		
		chat_bar_view.snp.makeConstraints{ (make) in
			make.bottom.left.right.equalTo(self)
			make.height.equalTo(50)
		}
		
		chat_text_view.snp.makeConstraints{ (make) in
			make.left.equalTo(chat_bar_view).inset(10)
			make.top.bottom.equalTo(chat_bar_view)
			make.right.equalTo(chat_send_button.snp.left)
		}

		chat_send_button.snp.makeConstraints{ (make) in
			make.top.bottom.right.equalTo(chat_bar_view)
			make.width.equalTo(50)
		}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
