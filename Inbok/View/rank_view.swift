//
//  rank_view.swift
//  Inbok
//
//  Created by seongjun cho on 3/2/24.
//

import Foundation
import UIKit
import SnapKit

class Rank_view : UIView {
	
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
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		self.backgroundColor = UIColor(named:"BACKGROUND")

		addSubview(head_view)
		head_view.addSubview(back_btn)
		
		
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
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
