//
//  Model.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation
import UIKit
import RealmSwift


class Help_model
{
    
    var posts : [[String: String]]
    //"name", "title", "content", "time", "profile_image"
    
    init()
    {
        self.posts = [[:]]
    }
}

class Talk_model
{
}

class User: Object {
	@Persisted var name: String
	@Persisted var profile_image: String
	@Persisted var helper: Bool//Are you helper?

}

class Message: Object {
    @Persisted var text: String
    @Persisted var profile_image: String
    @Persisted var time: String
    @Persisted var name: String

	init(text: String, profile_image: String, time: String, name: String) {
		self.text = text
		self.profile_image = profile_image
		self.time = time
		self.name = name
	}
	override init() {
	}
}

class Chat: Object {
	@Persisted var talker : User!
	@Persisted var recent_message: Message!//For fast making chat_list
	
	@Persisted var chatting = List<Message>() //It's each chatting messages
	
	override init() {
		talker = User()
		recent_message = Message()
	}
	init(index: Int, talker: User, recent_message: Message) {
		self.talker = talker
		self.recent_message = recent_message
	}	
}

class Chat_DB: Object {
	@Persisted var chat_list = List<Chat>()
}

class Chat_model
{
}

class Register_model
{
    var name : String?
    init() {
        self.name = ""
    }
}
