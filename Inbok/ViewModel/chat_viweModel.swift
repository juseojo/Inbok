//
//  chat_viweModel.swift
//  Inbok
//
//  Created by seongjun cho on 12/9/23.
//

import Foundation
import RMQClient
import RealmSwift

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
		message_obj.profile_image = UserDefaults.standard.string(forKey: "profile_image") ?? ""

		try! realm.write {
			chat_obj.chatting.append(message_obj)
		}
		
		//conn.close()
	}
}
