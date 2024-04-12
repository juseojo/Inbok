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
import Alamofire

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
		let conn = RMQConnection(uri: RMQ_host, delegate: RMQConnectionDelegateLogger())

		conn.start()
		
		let ch = conn.createChannel()
		let q = ch.queue(listener)
		ch.defaultExchange().publish(text.data(using: .utf8)!, routingKey: q.name)
		print("sent : \(text)")
		
		
		let message_obj = Message()

		message_obj.name = UserDefaults.standard.string(forKey: "name") ?? ""
		message_obj.text = message
		message_obj.time = date_formatter.string(from: Date())
		print("send time: \(message_obj.time)")
		message_obj.sent = true


		try! realm.write {
			chat_obj.chatting.append(message_obj)
			chat_obj.recent_message.text = message_obj.text
			chat_obj.recent_message.time = message_obj.time
		}
		if (conn.isClosed() == false)
		{
			conn.close()
		}
	}
	
	func end_talking_person(pesrson_name : String, type: Int)
	{
		let text = "/end_talk:\(String(describing: UserDefaults.standard.string(forKey: "name") ?? "none"))\(type)"
		let listener = pesrson_name
		let conn = RMQConnection(uri: RMQ_host, delegate: RMQConnectionDelegateLogger())

		conn.start()
		
		let ch = conn.createChannel()
		let q = ch.queue(listener)
		ch.defaultExchange().publish(text.data(using: .utf8)!, routingKey: q.name)

		if (conn.isClosed() == false)
		{
			conn.close()
		}
	}

	func end_talking_server(parameters: Dictionary<String, Any>)
	{
		print(parameters)

		AF.request("http://\(host)/end_talking", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON() { response in
			switch response.result {
			case .success:
				if let data = try! response.result.get() as? [String: String] {
					if (data["result"] == "success")
					{
						print("end talking success")
					}
					else
					{
						print("fail to end talking")
					}
				}
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}

	func delete_realm_chat(at: Int, closure: @escaping () -> Void)
	{
		let realm = try! Realm()
		if let delete = realm.objects(Chat_DB.self).first?.chat_list[at]{
			try! realm.write{
				realm.delete(delete.chatting)
				realm.delete(delete.talker)
				//realm.delete(delete.recent_message)
				realm.delete(delete)
			}
		}
		closure()
	}

	func cell_setting(cell: Chat_send_cell, index: Int, num: Int) -> Chat_send_cell
	{
		let realm = try! Realm()
		let chat: Message = realm.objects(Chat_DB.self).first?.chat_list[index].chatting[num] ?? Message()
		
		cell.selectionStyle = .none
		
		cell.message.text = chat.text
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 7)
		
		let date = date_formatter.date(from: chat.time)
		let time = time_diff(past_date: date!)
		switch time
		{
		case ...3600:
			let chat_time_formatter = DateFormatter()
			chat_time_formatter.dateFormat = "a h:mm"
			chat_time_formatter.locale = Locale(identifier: "ko_kr")
			chat_time_formatter.timeZone = TimeZone(abbreviation: "KST")
			cell.time.text = "\(chat_time_formatter.string(from: date!))"
		default:
			cell.time.text = "\(time/3600)일 전"
		}
		
		let new_size = cell.message.sizeThatFits(CGSize(width: screen_width - 50, height: CGFloat.greatestFiniteMagnitude))
		
		cell.message.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		cell.message.layer.cornerRadius = 10
		cell.message.layer.masksToBounds = true
		
		cell.message.layer.borderWidth = 1
		cell.message.layer.borderColor = UIColor.systemGray.cgColor
		cell.message.backgroundColor = UIColor.lightGray
		
		
		cell.message.snp.makeConstraints{ (make) in
			make.top.bottom.equalTo(cell).inset(5)
			make.right.equalTo(cell).offset(-10)
			make.width.greaterThanOrEqualTo(Int(new_size.width + 1))
			make.height.greaterThanOrEqualTo(Int(new_size.height)).priority(.high)
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

		if (chat.name == "/end_talk")
		{
			cell.message.text = chat.text
			cell.name.text = chat.name
		}
		cell.selectionStyle = .none

		cell.message.text = chat.text
		cell.name.text = chat.name
		
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 7)
		cell.name.font = UIFont(name:"SeoulHangang", size: 15)

		let date = date_formatter.date(from: chat.time)
		let time = time_diff(past_date: date!)
		switch time
		{
		case ...3600:
			let chat_time_formatter = DateFormatter()
			chat_time_formatter.dateFormat = "a h:mm"
			chat_time_formatter.locale = Locale(identifier: "ko_kr")
			chat_time_formatter.timeZone = TimeZone(abbreviation: "KST")
			cell.time.text = "\(chat_time_formatter.string(from: date!))"
		default:
			cell.time.text = "\(time/3600)일 전"
		}

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
		
		
		let new_size = cell.message.sizeThatFits(CGSize(width: screen_width - 50, height: CGFloat.greatestFiniteMagnitude))
		
		cell.profile_image.snp.makeConstraints{ (make) in
			make.top.equalTo(cell).inset(10)
			make.left.equalTo(cell).offset(10)
			make.width.height.equalTo(50)
		}
		cell.name.snp.makeConstraints{ (make) in
			make.top.equalTo(cell.profile_image.snp.top).inset(5)
			make.left.equalTo(cell.profile_image.snp.right).offset(10)
		}
		cell.message.snp.makeConstraints{ (make) in
			make.top.equalTo(cell.name.snp.bottom).inset(-5)
			make.left.equalTo(cell.profile_image.snp.right).offset(10)
			make.bottom.equalTo(cell).inset(1)
			make.height.greaterThanOrEqualTo(Int(new_size.height)).priority(.high)
			make.width.greaterThanOrEqualTo(Int(new_size.width + 1))
		}
		cell.time.snp.makeConstraints{ (make) in
			make.left.equalTo(cell.message.snp.right).offset(5)
			make.bottom.equalTo(cell.message.snp.bottom)
		}

		return cell
	}
}
