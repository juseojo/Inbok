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
		let conn = RMQConnection(uri: "amqp://admin:123690@43.202.245.98:5672/%2F",
								 delegate: RMQConnectionDelegateLogger())

		print(listener)

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

		cell.message.backgroundColor = UIColor.red //test code

		let new_size = cell.message.sizeThatFits(CGSize(width: screen_width, height: CGFloat.greatestFiniteMagnitude))
		
		
		cell.message.snp.makeConstraints{ (make) in
			make.top.right.bottom.equalTo(cell)
			make.width.equalTo(Int(new_size.width + 1))
			make.height.equalTo(Int(new_size.height ))
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
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 5)

		cell.profile_image.image = load_image(name: chat.name)
		cell.profile_image.tintColor = .systemGray
		cell.profile_image.layer.borderWidth = 1
		cell.profile_image.layer.cornerRadius = 10
		cell.profile_image.clipsToBounds = true
		cell.profile_image.layer.borderColor = UIColor.systemGray.cgColor
		
		cell.message.backgroundColor = UIColor.blue	//test code

		
		let new_size = cell.message.sizeThatFits(CGSize(width: screen_width, height: CGFloat.greatestFiniteMagnitude))
		
		cell.profile_image.snp.makeConstraints{ (make) in
			make.top.left.equalTo(cell)
			make.width.height.equalTo(50)
		}
		cell.name.snp.makeConstraints{ (make) in
			make.left.equalTo(cell.profile_image.snp.right).offset(10)
			make.bottom.equalTo(cell.profile_image)
			make.top.equalTo(cell)
		}
		cell.message.snp.makeConstraints{ (make) in
			make.top.equalTo(cell.name.snp.bottom)
			make.left.equalTo(cell.name.snp.right)
			make.bottom.equalTo(cell)
			make.height.equalTo(Int(new_size.height))
			make.width.equalTo(Int(new_size.width + 1))
		}
		cell.time.snp.makeConstraints{ (make) in
			make.left.equalTo(cell.message.snp.right).offset(5)
			make.bottom.equalTo(cell.message.snp.bottom)
		}

		
		return cell
	}
}
