//
//  rank_cell.swift
//  Inbok
//
//  Created by seongjun cho on 3/24/24.
//

import UIKit

import SnapKit

class Rank_cell: UITableViewCell {
	
	static let cell_id = "rank"
	
	var profile = UIImageView()
	var nick_name = UILabel()
	var rank = UILabel()
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier:  reuseIdentifier)
		
		layout()
	}

	required init?(coder: NSCoder) {
		fatalError("init error")
	}

	func layout()
	{
		self.addSubview(profile)
		self.addSubview(nick_name)
		self.addSubview(rank)
		
		profile.tintColor = UIColor.gray
		//profile.contentMode = .scaleAspectFit
		profile.layer.cornerRadius = 10.0
		profile.clipsToBounds = true
		
		profile.snp.makeConstraints{ (make) in
			make.top.bottom.right.equalTo(self).inset(10)
			make.width.equalTo(self.snp.height).inset(10)
		}

		nick_name.snp.makeConstraints{ (make) in
			make.top.bottom.equalTo(self).inset(10)			
			make.right.equalTo(profile.snp.left).inset(-10)
		}
		
		rank.snp.makeConstraints{ (make) in
			make.top.bottom.left.equalTo(self).inset(10)
		}
	}
}
