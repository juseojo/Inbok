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
    
    var head_text: String {
        return help_model.page_name
    }
    
    var head_btn_image: UIImage{
        return help_model.head_btn_image
    }
    func get_new_post(offset: Int) -> Bool
    {
        print("hi\n")
       // let offset: Parameters = ["offset" : offset]
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global(qos: .userInitiated).async
        {
            let session = URLSession.shared
            
            var url = URL(string: "http://\(host)/get_new_post?offset=\(offset)")
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            session.dataTask(with: request){ data, response, error in
                guard error == nil else {
                    print("Error: error calling GET")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                guard let output = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    print("json to Any Error")
                    return
                }
                for post in output as! Array<Array<String>>
                {
                    if (post[0] != "result")
                    {
                        self.help_model.posts.append(["name" : post[0] , "title": post[1] , "content": post[2] , "time": post[3] , "profile_image": post[4] ])
                    }
                }
                self.help_model.posts.removeFirst()
                semaphore.signal()
            }.resume()
        }
        semaphore.wait()
        print("bye\n")
        
        
        return true
    }
    
    func cell_setting (cell : post_cell, index: Int) -> post_cell
    {
        print(index)
        if (index == 0)
        {
            get_new_post(offset: 0)
            print("we got post")
            print(self.help_model.posts)
        }
        if (self.help_model.posts.isEmpty)
        {
            return cell
        }
        if (self.help_model.posts.count <= index)
        {
            return cell
        }
        
        cell.nick_name.text = self.help_model.posts[index]["name"] ?? "none"
        cell.problem.text = self.help_model.posts[index]["content"] ?? "none"
        cell.time.text = self.help_model.posts[index]["time"] ?? "none"
        
        let profile = self.help_model.posts[index]["profile_image"] ?? "none"
        
        let url : URL! = URL(string: profile)
        let data = try! Data(contentsOf: url)
        cell.profile.image = UIImage(data: data)!

        return cell
    }
    
    func login(help_vc : UIViewController, regist_vc : UIViewController)
    {
        if UserDefaults.standard.bool(forKey: "launchBefore") == false
        {
            print("\nRun first\n")
            help_vc.present(regist_vc, animated: false)
        }
        else if UserDefaults.standard.object(forKey: "oauth_token") == nil
        {
            print("\nNot first run but oauth not found\n")
            help_vc.present(regist_vc, animated: false)
        }
        else if UserDefaults.standard.string(forKey: "name") == nil
        {
            print("pass oauth but regist not success by name\n")
            help_vc.present(regist_vc, animated: false)
        }
        else
        {
            print("\nNomal login\n\n")
            
            //for test code
            //UserDefaults.standard.set(nil, forKey: "oauth_token")
            //UserDefaults.standard.set(nil, forKey: "id")
            //UserDefaults.standard.set(false, forKey: "launchBefore")
            //it must be delete
        }
    }
}

extension Help_viewModel {
    func configure(_ view: Help_view) {
        view.head_label.text = head_text
        view.head_btn.setImage(head_btn_image, for: .normal)
    }
}
