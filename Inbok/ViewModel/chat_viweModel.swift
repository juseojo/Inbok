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
	
	init(){
		self.chat_model = Chat_model()
	}
	
	func send(listener : String, message : String)
	{
		let conn = RMQConnection(uri: "amqp://admin:123690@43.202.245.98:5672/%2F",
								 delegate: RMQConnectionDelegateLogger())
		conn.start()
		
		let ch = conn.createChannel()
		let q = ch.queue(listener)
		ch.defaultExchange().publish(message.data(using: .utf8)!, routingKey: q.name)
		print("sent")
				
		let _ = add_realm(
			realm: chat_model.chat_DB,
			name: UserDefaults.standard.string(forKey: "name")!,
			text: message,
			time: Date().toString(),
			profile_image: UserDefaults.standard.string(forKey: "profile_image")!)
		
		conn.close()
	}
	
	func add_realm(realm: Realm,name: String, text: String, time: String, profile_image: String) -> Message {
		
		let message = Message()
		
		message.name = name
		message.text = text
		message.time = time
		message.profile_image = profile_image
		
		try! realm.write {
			realm.add(message)
		}
		
		return message
	}
}
