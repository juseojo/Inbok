//
//  inform_view.swift
//  Inbok
//
//  Created by seongjun cho on 3/26/24.
//

import UIKit

import SnapKit

class Inform_view : UIView {
	
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
		head_label.text = "나의 정보"
		
		return head_label
	}()
	
	let profile_image: UIImageView = {
		let profile_image = UIImageView()

		profile_image.tintColor = UIColor.systemGray
		profile_image.image = UIImage(systemName: "person.fill")
		profile_image.layer.cornerRadius = 10.0
		profile_image.clipsToBounds = true

		return profile_image
	}()
	
	let name_label: UILabel = {
		let name_label = UILabel()
		
		name_label.text = UserDefaults.standard.string(forKey: "name") ?? "none"
		name_label.font = UIFont(name:"SeoulHangang", size: 20)
		name_label.textColor = UIColor(named: "REVERSE_SYS")
		name_label.textAlignment = .center
		
		return name_label
	}()
	
	let point_view: UIView = {
		let point_view = UIView()

		point_view.backgroundColor = UIColor.white
		point_view.clipsToBounds = true
		point_view.layer.cornerRadius = 10.0

		return point_view
	}()
	
	let point_image: UIImageView = {
		let point_image = UIImageView()
		
		point_image.image = UIImage(named: "help")
		point_image.contentMode = .scaleAspectFit

		return point_image
	}()
	
	let point_label: UILabel = {
		let point_label = UILabel()
		
		point_label.text = "point : " + (UserDefaults.standard.string(forKey: "point") ?? "none")
		point_label.font = UIFont(name:"SeoulHangang", size: 20)

		return point_label
	}()
	
	let charge_label: UILabel = {
		let charge_label = UILabel()
		
		charge_label.text = "충전하기 +"
		charge_label.font = UIFont(name:"SeoulHangang", size: 20)
		charge_label.textColor = UIColor.black
		charge_label.textAlignment = .center
		charge_label.backgroundColor = UIColor.white
		charge_label.layer.opacity = 0.51
		charge_label.layer.cornerRadius = 10.0
		charge_label.clipsToBounds = true
		
		return charge_label
	}()

	override init(frame: CGRect) {

		super.init(frame: frame)

		addSubview(head_view)
		head_view.addSubview(head_label)
		
		addSubview(profile_image)
		addSubview(name_label)

		addSubview(point_view)
		point_view.addSubview(point_image)
		point_view.addSubview(point_label)
		point_view.addSubview(charge_label)

		head_view.snp.makeConstraints{ (make) in
			make.top.equalTo(self.snp.top)
			make.width.equalTo(self.snp.width)
			make.height.equalTo(head_height)
		}
		
		head_label.snp.makeConstraints{ (make) in
			make.top.equalTo(head_view).inset(7)
			make.left.equalTo(head_view).inset(15)
		}

		profile_image.snp.makeConstraints { (make) in
			make.top.equalTo(head_view.snp.bottom).inset(-10)
			make.centerX.equalTo(self.snp.centerX)
			make.width.height.equalTo(screen_width/3)
		}

		name_label.snp.makeConstraints { (make) in
			make.top.equalTo(profile_image.snp.bottom).inset(-10)
			make.centerX.equalTo(profile_image.snp.centerX)
			make.width.equalTo(screen_width * 0.8)
			make.height.equalTo(20)
		}
		
		point_view.snp.makeConstraints { (make) in
			make.top.equalTo(name_label.snp.bottom).inset(-10)
			make.left.right.equalTo(self).inset(10)
			make.height.equalTo(screen_height * 0.2)
		}
		
		point_image.snp.makeConstraints { make in
			make.top.left.equalTo(point_view).inset(10)
			make.width.height.equalTo(50)
		}
		
		point_label.snp.makeConstraints { make in
			make.top.equalTo(point_view).inset(10)
			make.left.equalTo(point_image.snp.right).inset(-10)
			make.height.equalTo(point_image.snp.height)
			make.right.equalTo(point_view).inset(10)
		}
		
		charge_label.snp.makeConstraints { make in
			make.top.equalTo(point_label.snp.bottom).inset(-10)
			make.left.right.equalTo(point_view).inset(screen_width/5)
			make.bottom.equalTo(point_view).inset(40)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
