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
		let conn = RMQConnection(uri: "amqp://admin:123690@43.202.245.98:5672/%2F",
								 delegate: RMQConnectionDelegateLogger())
		conn.start()
		let ch = conn.createChannel()
		let q = ch.queue(UserDefaults.standard.string(forKey: "name") ?? "Unknouwn")
		
		q.subscribe({(_ message: RMQMessage) -> Void in
			self.got_message(
				String(data: message.body, encoding: String.Encoding.utf8) ?? "",
				talk_tableView)
		})
		
		print("receive set")
	}
	
	func got_message(_ message: String, _ talk_tableView : UITableView)
	{
		var name: String = ""
		var text: String = ""
		var name_flag: Bool = true
		let chat_list = talk_model.chat_DB.objects(Chat.self).sorted(byKeyPath: "index", ascending: true)

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
		
		var overlap_flag: Bool = false
		var count = 0
		
		//talker overlap check and renew
		for chat in chat_list
		{
			//overlap
			if (chat.talker_name == name)
			{
				overlap_flag = true

				//renew
				try! talk_model.chat_DB.write{
					chat.recent_message.text = text
					chat.recent_message.time = Date().toString()
				}
			}
			count += 1
		}
		
		//First talking, Regist to talk_model
		if (!overlap_flag)
		{
			let user_inform = get_user_inform(name: name)
			
			let chat = Chat()
			let message = Message()
			
			message.name = name
			message.text = text
			message.time = Date().toString()
			message.profile_image = user_inform["profile_image"]!
			
			chat.recent_message = message
			chat.helping = false
			chat.chatting.append(message)
			chat.index = count

			try! talk_model.chat_DB.write{
				talk_model.chat_DB.add(chat)
			}

			//append tableview element
			let index:IndexPath = IndexPath(row: chat_list.count, section: 0)
			
			UIView.performWithoutAnimation {
				talk_tableView.insertRows(at: [index], with: .none)
			}
		}
	}
	
	func cell_setting(cell : Talk_cell, index : Int) -> Talk_cell
	{
		let chat = self.talk_model.chat_DB.objects(Chat.self).sorted(byKeyPath: "index", ascending: true)[index]
		let recent_message = chat.recent_message

		cell.nick_name.text = recent_message?.name
		cell.message.text = recent_message?.text
		cell.time.text = recent_message?.time
		
		cell.nick_name.font = UIFont(name:"SeoulHangang", size: 20)
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 15)
		
		//profile round
		cell.profile.layer.cornerRadius = 4
		cell.profile.clipsToBounds = true
		
		let profile = recent_message?.profile_image
		
		//url to image and set profile
		let url : URL! = URL(string: profile!)
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let imageData = data
			else {
				DispatchQueue.main.async {
					cell.profile.image = UIImage(systemName: "person.fill")
					cell.profile.tintColor = UIColor.systemGray
				}
				return
			}
			DispatchQueue.main.async {
				cell.profile.image = UIImage(data: imageData)
			}
		}.resume()
		
		return cell
	}
}
