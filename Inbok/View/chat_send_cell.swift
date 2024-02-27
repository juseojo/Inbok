//
//  chat_send_cell.swift
//  Inbok
//
//  Created by seongjun cho on 1/20/24.
//

import UIKit
import SnapKit

class Chat_send_cell: UITableViewCell {
	static let cell_id = "chat_send"
	
	var message = UITextView()
	var time = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier:  reuseIdentifier)
		
		self.backgroundColor = UIColor(named: "BACKGROUND")
		self.addSubview(message)
		self.addSubview(time)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init error")
	}
	
	override func prepareForReuse() {
		
		message.text = nil
		time.text = nil
		message.snp.removeConstraints()
	}
}
