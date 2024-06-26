//
//  chat_receive_cell.swiftx
//  Inbok
//
//  Created by seongjun cho on 1/20/24.
//

import UIKit

import SnapKit

class Chat_receive_cell: UITableViewCell {
	static let cell_id = "chat_receive"
	
	var message = UITextView()
	var time = UILabel()

	var profile_image = UIImageView()
	var name = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier:  reuseIdentifier)
		self.backgroundColor = UIColor(named: "BACKGROUND")

		
		self.addSubview(message)
		self.addSubview(time)
		self.addSubview(profile_image)
		self.addSubview(name)
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
