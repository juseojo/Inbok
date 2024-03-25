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
    //"name", "title", "content", "time", "profile_image", "point"
    
    init()
    {
        self.posts = [[:]]
    }
}

class Rank_model
{
	var rankers : [[String: String]]
	
	init()
	{
		self.rankers = [[:]]
		//"rank", "name", "profile"
		//"first_ranker is always user"
	}
}

class Talk_model
{
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

class User: Object {
	@Persisted var name: String
	@Persisted var helper: Bool//Are you helper?

}

class Message: Object {
    @Persisted var text: String
    @Persisted var time: String
    @Persisted var name: String
	@Persisted var sent: Bool

	init(text: String, time: String, name: String, sent: Bool) {
		self.text = text
		self.time = time
		self.name = name
		self.sent = sent
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
	init(talker: User, recent_message: Message) {
		self.talker = talker
		self.recent_message = recent_message
	}	
}

class Chat_DB: Object {
	@Persisted var chat_list = List<Chat>()
}
