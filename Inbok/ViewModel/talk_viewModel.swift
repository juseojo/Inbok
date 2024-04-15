//
//  talk_viewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import UIKit
import RMQClient
import RealmSwift

class Talk_viewModel {
	let talk_model: Talk_model
	
	init(){
		self.talk_model = Talk_model()
		
	}
	
	func receive(_ talk_tableView : UITableView)
	{
		let conn = RMQConnection(uri: RMQ_host,
								 delegate: RMQConnectionDelegateLogger())
		conn.start()
		let ch = conn.createChannel()
		let q = ch.queue(UserDefaults.standard.string(forKey: "name") ?? "none")
		
		q.subscribe({(_ message: RMQMessage) -> Void in
			self.got_message(
				String(data: message.body, encoding: String.Encoding.utf8) ?? "")
		})
		
		print("receive set")
	}
	
	func got_message(_ message: String)
	{
		print("receive msg : \(message)")
		var name: String = ""
		var text: String = ""
		var name_flag: Bool = true
				
		//substr name:text
		for c in message
		{
			if (name_flag && c == ":" as Character)
			{
				name_flag = false
				continue
			}
			
			if (name_flag)
			{
				name += "\(c)"
			}
			else
			{
				text += "\(c)"
			}
		}

		//talking case check
		let realm = try! Realm()
		let talkers = realm.objects(Chat_DB.self).first
		let chat = Chat()
		let message = Message()
		let chatting_list = realm.objects(Chat_DB.self).first?.chat_list

		if (name == "/start_talk")
		{
			let new_user_name = text
			message.name = new_user_name
			message.text = ""
			message.time = date_formatter.string(from: Date())
			message.sent = false
			
			chat.recent_message = message
			chat.talker.helper = true
			chat.talker.name = new_user_name
			chat.chatting.append(message)
			
			try! realm.write{
				if (talkers == nil)
				{
					let chat_DB = Chat_DB()
					chat_DB.chat_list.append(chat)
					realm.add(chat_DB)
				}
				talkers?.chat_list.append(chat)
				DispatchQueue.main.async {
					NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				}
			}
			
			get_user_inform(name: new_user_name) { user_inform in
				//url to image and saving profile
				save_image(url_string: user_inform["profile_image"] ?? "none", name: new_user_name)
			}
			return
		}
		else if (name == "/end_talk")
		{
			let type = text.popLast() ?? "0"
			let end_user = chatting_list?.where {
				$0.talker.name == text
			}.first

			let end_message = Message(
				text: String(describing: type),
				time: date_formatter.string(from: Date()),
				name: "/end_talk",
				sent: false
			)
			try! realm.write{
				end_user?.chatting.append(end_message)
			}
			return
		}
		
		//nomal message case
		let overlap_user = chatting_list?.where {
			$0.talker.name == name
		}.first

		if (overlap_user != nil)
		{
			let message = Message(
				text: text,
				time: date_formatter.string(from: Date()),
				name: overlap_user!.talker.name,
				sent: false
			)
			//renew
			try! realm.write{
				overlap_user!.recent_message.text = text
				overlap_user!.recent_message.time = date_formatter.string(from: Date())
				overlap_user!.chatting.append(message)
			}
			NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
		}
	}
	
	func cell_setting(cell : Talk_cell, index : Int) -> Talk_cell
	{
		let realm = try! Realm()
		if (realm.objects(Chat_DB.self).first?.chat_list.isEmpty ?? true)
		{
			print("test : \(index)")
			return cell
		}
		print("cell set : \(index)")
		let chat : Chat = realm.objects(Chat_DB.self).first?.chat_list[index] ?? Chat()
		let recent_message = chat.recent_message!

		cell.nick_name.text = recent_message.name
		cell.message.text = recent_message.text
		
		let date = date_formatter.date(from: recent_message.time)
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
		
		cell.nick_name.font = UIFont(name:"SeoulHangang", size: 20)
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 15)
		
		//time layout
		let new_size = cell.time.sizeThatFits(CGSize(width: screen_width/2, height: 20))
		cell.time.snp.makeConstraints{ (make) in
			make.bottom.equalTo(cell.snp.bottom).inset(20)
			make.right.equalTo(cell.snp.right).inset(20)
			make.width.equalTo(new_size.width).priority(.high)
		}
		
		//profile round
		cell.profile.layer.cornerRadius = 4
		cell.profile.clipsToBounds = true
		cell.profile.image = load_image(name:recent_message.name)

		return cell
	}
}
