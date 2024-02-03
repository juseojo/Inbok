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
		let q = ch.queue(UserDefaults.standard.string(forKey: "name") ?? "none")
		
		q.subscribe({(_ message: RMQMessage) -> Void in
			self.got_message(
				String(data: message.body, encoding: String.Encoding.utf8) ?? "",
				talk_tableView)
		})
		
		print("receive set")
	}
	
	func got_message(_ message: String, _ talk_tableView : UITableView)
	{
		print("receive msg : \(message)")
		var name: String = ""
		var text: String = ""
		var name_flag: Bool = true
		let realm = try! Realm()
				
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
		
		
		//**********************it's have to test*****************
		//talker overlap check and renew
		let chat_list = realm.objects(Chat_DB.self).first?.chat_list
		
		let overlap_user = chat_list?.where {
			$0.talker.name == name
		}.first

		if (overlap_user != nil)
		{
			let message = Message(
				text: text,
				profile_image: overlap_user!.talker.profile_image,
				time: Date().toString(),
				name: overlap_user!.talker.name,
				sent: false
			)
			//renew
			try! realm.write{
				overlap_user!.recent_message.text = text
				overlap_user!.recent_message.time = Date().toString()
				overlap_user!.chatting.append(message)
			}
		}
		else //First talking, Regist to talk_model
		{
			let user_inform = get_user_inform(name: name)
			
			let list = realm.objects(Chat_DB.self).first
			let chat = Chat()
			let message = Message()

			message.name = name
			message.text = text
			message.time = Date().toString()
			message.profile_image =  user_inform["profile_image"] ?? "none"
			message.sent = false
			
			chat.recent_message = message

			chat.talker.helper = true
			chat.talker.name = name
			chat.talker.profile_image = user_inform["profile_image"] ?? "none"
			chat.chatting.append(message)

			try! realm.write{
				realm.add(chat)
				if (list == nil){
					let chat_DB = Chat_DB()
					chat_DB.chat_list.append(chat)
					realm.add(chat_DB)
				}

				list?.chat_list.append(chat)
			}
			
			//append tableview element
			let index:IndexPath = IndexPath(row: chat_list!.count, section: 0)
			
			UIView.performWithoutAnimation {
				talk_tableView.insertRows(at: [index], with: .none)
			}
		}
	}
	
	func cell_setting(cell : Talk_cell, index : Int) -> Talk_cell
	{
		let realm = try! Realm()
		let chat : Chat = realm.objects(Chat_DB.self).first?.chat_list[index] ?? Chat()
		let recent_message = chat.recent_message!

		cell.nick_name.text = recent_message.name
		cell.message.text = recent_message.text
		cell.time.text = recent_message.time
		
		cell.nick_name.font = UIFont(name:"SeoulHangang", size: 20)
		cell.message.font = UIFont(name:"SeoulHangang", size: 15)
		cell.time.font = UIFont(name:"SeoulHangang", size: 15)
		
		//profile round
		cell.profile.layer.cornerRadius = 4
		cell.profile.clipsToBounds = true
		
		let profile = recent_message.profile_image
		
		//url to image and set profile
		if (profile == "none" || profile == "nil")
		{
			cell.profile.image = UIImage(systemName: "person.fill")
			cell.profile.tintColor = UIColor.systemGray
		}
		else
		{
			let url : URL! = URL(string: profile)
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
		}
		return cell
	}
}
