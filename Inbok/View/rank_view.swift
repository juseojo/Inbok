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
	
	let head_label: UILabel = {
		let head_label = UILabel()

		head_label.textAlignment = .left
		head_label.textColor = UIColor(named: "REVERSE_SYS")
		head_label.font = UIFont(name:"SeoulHangang", size: 20)
		head_label.text = "랭킹 페이지"
		
		return head_label
	}()

	let body_view: UIView = {
		let body_view = UIView()

		body_view.backgroundColor = UIColor.white
		body_view.layer.cornerRadius = 10.0
		body_view.clipsToBounds = true
		
		return body_view
	}()

	let rank_tableView: UITableView = {
		let rank_tableView = UITableView()
		
		rank_tableView.layer.cornerRadius = 10.0
		rank_tableView.clipsToBounds = true
		
		rank_tableView.rowHeight = 70
		rank_tableView.register(Rank_cell.self, forCellReuseIdentifier: "rank")
		rank_tableView.backgroundColor = UIColor.white

		return rank_tableView
	}()
	
	var first_image_view = Rank_image_view(profile_image: UIImage(systemName: "person.fill")!, medal_color: UIColor.yellow)
	var second_image_view = Rank_image_view(profile_image: UIImage(systemName: "person.fill")!, medal_color: UIColor.lightGray)
	var third_image_view = Rank_image_view(profile_image: UIImage(systemName: "person.fill")!, medal_color: UIColor.brown)
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		self.backgroundColor = UIColor(named:"BACKGROUND")

		head_view.addSubview(head_label)
		addSubview(head_view)
		
		body_view.addSubview(first_image_view)
		body_view.addSubview(second_image_view)
		body_view.addSubview(third_image_view)
		addSubview(body_view)
		addSubview(rank_tableView)
		
		head_view.snp.makeConstraints{ (make) in
			make.top.equalTo(self.snp.top)
			make.width.equalTo(self.snp.width)
			make.height.equalTo(head_height)
		}
		
		head_label.snp.makeConstraints{ (make) in
			make.top.equalTo(head_view).inset(7)
			make.left.equalTo(head_view).inset(15)
		}
		
		body_view.snp.makeConstraints { (make) in
			make.top.equalTo(head_view.snp.bottom).inset(-10)
			make.bottom.left.right.equalTo(self).inset(10)
		}
		
		first_image_view.snp.makeConstraints { (make) in
			make.centerX.equalTo(body_view.snp.centerX)
			make.top.equalTo(body_view).inset(10)
			make.width.equalTo(screen_width/3)
			make.height.equalTo(screen_width/3).priority(.high)
		}
		
		second_image_view.snp.makeConstraints { (make) in
			make.top.equalTo(first_image_view.snp.bottom).inset(-10)
			make.left.equalTo(body_view).inset(10)
			make.width.height.equalTo(screen_width/3)
		}
		
		third_image_view.snp.makeConstraints { (make) in
			make.top.equalTo(first_image_view.snp.bottom).inset(-10)
			make.right.equalTo(body_view).inset(10)
			make.width.height.equalTo(screen_width/3)
		}
		
		rank_tableView.snp.makeConstraints { (make) in
			make.top.equalTo(second_image_view.snp.bottom).inset(-10)
			make.left.right.bottom.equalTo(body_view).inset(10)
		}
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class Rank_image_view: UIView {

	let profile_image_view: UIImageView = {
		let profile_image_view = UIImageView()

		profile_image_view.tintColor = UIColor.gray
		profile_image_view.backgroundColor = UIColor.white
		profile_image_view.layer.cornerRadius = 10.0
		profile_image_view.clipsToBounds = true

		
		return profile_image_view
	}()
	
	let medal_image_view: UIImageView = {
	let medal_image_view = UIImageView()
	
	medal_image_view.image = UIImage(systemName: "medal.fill")
	
	return medal_image_view
	}()

	init(profile_image: UIImage, medal_color: UIColor) {
		super.init(frame: CGRect.zero)
		
		addSubview(profile_image_view)
		addSubview(medal_image_view)
		
		profile_image_view.image = profile_image
		medal_image_view.tintColor = medal_color
		
		profile_image_view.snp.makeConstraints { (make) in
			make.top.right.left.bottom.equalTo(self)
		}

		medal_image_view.snp.makeConstraints { (make) in
			make.bottom.right.equalTo(profile_image_view)
			make.width.height.equalTo(50)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
