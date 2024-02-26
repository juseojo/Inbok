//
//  chat_viweModel.swift
//  Inbok
//
//  Created by seongjun cho on 12/9/23.
//

import Foundation
import RMQClient
import RealmSwift
import SnapKit

class Chat_viewModel {
	
	let chat_model: Chat_model
	var index: Int
	
	init(_ index: Int){
		self.index = index
		self.chat_model = Chat_model()
	}
	
	func send(message : String)
	{
		let text = "\(UserDefaults.standard.string(forKey: "name") ?? ""):\(message)"
		let realm = try! Realm()
		let chat_obj : Chat = realm.objects(Chat_DB.self).first?.chat_list[index] ?? Chat()
		let listener = chat_obj.talker.name
		let conn = RMQConnection(uri: RMQ_host,
								 delegate: RMQConnectionDelegateLogger())

		conn.start()
		
		let ch = conn.createChannel()
		let q = ch.queue(listener)
		ch.defaultExchange().publish(text.data(using: .utf8)!, routingKey: q.name)
		print("sent : \(text)")
		
		
		let message_obj = Message()

		message_obj.name = UserDefaults.standard.string(forKey: "name") ?? ""
		message_obj.text = message
		message_obj.time = Date().toString()
		message_obj.sent = true


		try! realm.write {
			chat_obj.chatting.append(message_obj)
		}
		//conn.close()
	}
	func cell_setting(cell: Chat_send_cell, index: Int, num: Int) -> Chat_send_cell
	{
		let realm = try! Realm()
		let chat: Message = realm.objects(Chat_DB.self).first?.chat_list[index].chatting[num] ?? Message()
		
		cell.selectionStyle = .none
		
		cell.message.text = chat.text
		cell.time.text = chat.time
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 5)

		let new_size = cell.message.sizeThatFits(CGSize(width: screen_width, height: CGFloat.greatestFiniteMagnitude))
		
		cell.message.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		cell.message.layer.cornerRadius = 10
		cell.message.layer.masksToBounds = true
		
		cell.message.layer.borderWidth = 1
		cell.message.layer.borderColor = UIColor.systemGray.cgColor
		cell.message.backgroundColor = UIColor.lightGray
		
		
		cell.message.snp.makeConstraints{ (make) in
			make.top.bottom.equalTo(cell)
			make.right.equalTo(cell).offset(-10)
			make.width.greaterThanOrEqualTo(Int(new_size.width + 1))
			make.height.greaterThanOrEqualTo(Int(new_size.height ))
		}
		cell.time.snp.makeConstraints{ (make) in
			make.right.equalTo(cell.message.snp.left).offset(-5)
			make.bottom.equalTo(cell.message.snp.bottom)
		}

		return cell
	}
	
	func cell_setting(cell: Chat_receive_cell, index: Int, num: Int) -> Chat_receive_cell
	{
		let realm = try! Realm()
		let chat: Message = realm.objects(Chat_DB.self).first?.chat_list[index].chatting[num] ?? Message()

		cell.selectionStyle = .none

		cell.message.text = chat.text
		cell.time.text = chat.time
		cell.name.text = chat.name
		
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 5)
		cell.name.font = UIFont(name:"SeoulHangang", size: 15)

		cell.profile_image.image = load_image(name: chat.name)
		cell.profile_image.tintColor = .systemGray
		cell.profile_image.layer.borderWidth = 1
		cell.profile_image.layer.borderColor = UIColor.systemGray.cgColor
		cell.profile_image.layer.cornerRadius = 10
		cell.profile_image.clipsToBounds = true

		cell.message.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
		cell.message.layer.cornerRadius = 10
		cell.message.layer.masksToBounds = true
		
		cell.message.layer.borderWidth = 1
		cell.message.layer.borderColor = UIColor.systemGray.cgColor
		cell.message.backgroundColor = UIColor.lightGray
		
		
		let new_size = cell.message.sizeThatFits(CGSize(width: screen_width, height: CGFloat.greatestFiniteMagnitude))
		
		cell.profile_image.snp.makeConstraints{ (make) in
			make.top.equalTo(cell)
			make.left.equalTo(cell).offset(5)
			make.width.height.equalTo(50)
		}
		cell.name.snp.makeConstraints{ (make) in
			make.left.equalTo(cell.profile_image.snp.right).offset(10)
			make.bottom.equalTo(cell.profile_image)
			make.top.equalTo(cell)
		}
		cell.message.snp.makeConstraints{ (make) in
			make.top.equalTo(cell.name.snp.bottom)
			make.left.equalTo(cell.profile_image.snp.right).offset(5)
			make.bottom.equalTo(cell)
			make.height.greaterThanOrEqualTo(Int(new_size.height))
			make.width.greaterThanOrEqualTo(Int(new_size.width + 1))
		}
		cell.time.snp.makeConstraints{ (make) in
			make.left.equalTo(cell.message.snp.right).offset(5)
			make.bottom.equalTo(cell.message.snp.bottom)
		}

		return cell
	}
}
