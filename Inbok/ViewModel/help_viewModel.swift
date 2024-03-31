//
//  help_viewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2023/09/07.
//

import Foundation
import UIKit
import SwiftUI
import Alamofire

class Help_viewModel {
    
    init(help_model:Help_model){
        self.help_model = help_model
    }
    
    let help_model: Help_model

	func get_new_post(offset: Int, error_handler: @escaping  (Bool) -> Void)
    {
        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.global(qos: .userInitiated).async
        {
            let session = URLSession.shared
            let url = URL(string: "http://\(host)/get_new_post?offset=\(offset)")
            var request = URLRequest(url: url!)
			
			
            request.httpMethod = "GET"
            session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling GET")
                    print(error!)
					error_handler(true)
					semaphore.signal()
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
					error_handler(true)
					semaphore.signal()
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                    print("Error: HTTP request failed")
					error_handler(true)
					semaphore.signal()
                    return
                }
                guard let output = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    print("json to Any Error")
					error_handler(true)
					semaphore.signal()
                    return
                }
				for post in output as! Array<Array<String>>
                {
                    if (post[0] != "result")
					{
						self.help_model.posts.append(["name" : post[0] , "title": post[1] , "content": post[2] , "time": post[3] , "profile_image": post[4], "point": post[5], "helper_name": post[5]])
					}
                }
                semaphore.signal()
            }.resume()
        }
        semaphore.wait()
    }
    
    func cell_setting (cell : Post_cell, index: Int) -> Post_cell
    {
        if (self.help_model.posts.isEmpty)
        {
            return cell
        }
        if (self.help_model.posts.count <= index)
        {
            return cell
        }
        
        //time set
        let date = date_formatter.date(from: self.help_model.posts[index]["time"] ?? "none")
        let time = time_diff(past_date: date!)
        switch time
        {
        case ...1:
            cell.time.text = "몇초 전"
        case ...60:
            cell.time.text = "\(time)분 전"
        case ...3600:
            cell.time.text = "\(time/60)시간 전"
        default:
            cell.time.text = "\(time/3600)일 전"
        }
        
        cell.nick_name.text = self.help_model.posts[index]["name"] ?? "none"
        cell.title.text = self.help_model.posts[index]["title"] ?? "none"
        
        
        cell.nick_name.font = UIFont(name:"SeoulHangang", size: 20)
        cell.title.font = UIFont(name:"SeoulHangang", size: 20)
        cell.time.font = UIFont(name:"SeoulHangang", size: 15)
        
        //profile round
        cell.profile.layer.cornerRadius = 4
        cell.profile.clipsToBounds = true
        
        let profile = self.help_model.posts[index]["profile_image"] ?? "none"
        
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

    func login() -> Bool
    {		
        if UserDefaults.standard.bool(forKey: "launchBefore") == false
        {
            print("Run first")

			return false
        }
        else if UserDefaults.standard.string(forKey: "name") == nil
        {
            print("Not regist account")
			
			return false
        }
        else
        {
            print("Nomal login")
			
			get_user_inform(name: UserDefaults.standard.string(forKey: "name") ?? "none") { user_inform in
				UserDefaults.standard.setValue(user_inform["point"], forKey: "point")
				UserDefaults.standard.setValue(user_inform["profile_image"], forKey: "profile_image")
			}
			
            //for test code
            UserDefaults.standard.set(nil, forKey: "id")
            UserDefaults.standard.set(false, forKey: "launchBefore")
			UserDefaults.standard.set(nil, forKey: "name")
            //it must be delete
			
			return true
        }
    }
}
