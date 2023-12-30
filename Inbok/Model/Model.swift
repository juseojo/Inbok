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
	var chat_DB : Realm

	init()
	{
		chat_DB = try! Realm()
	}
}

class Message: Object {
    @Persisted var text: String
    @Persisted var profile_image: String
    @Persisted var time: String
    @Persisted var name: String
}

class Chat: Object {
	@Persisted var index: Int
	@Persisted var helping: Bool//Am i helper?
	@Persisted var talker_name: String
	@Persisted var recent_message: Message!//For fast making chat_list
	
	let chatting = List<Message>() //It's each chatting messages
}

class Chat_model
{
    var chat_DB: Realm
	
	init()
	{
		chat_DB = try! Realm()
	}
}

class Register_model
{
    var name : String?
    init() {
        self.name = ""
    }
}
