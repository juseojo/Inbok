//
//  post_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 11/7/23.
//

import UIKit

import SnapKit
import Alamofire
import RMQClient

class Post_ViewController : UIViewController {
	
	let post_view = Post_view()
	//for send to talk_view
	var talker_name = ""
	var talker_profile = ""
	
	override func viewDidLoad() {
		
		self.tabBarController?.tabBar.isHidden = true
		
		self.view.backgroundColor = UIColor(named: "BACKGROUND")
		post_view.backgroundColor = UIColor(named: "BACKGROUND")
		
		post_view.back_btn.addTarget(self, action: #selector(back_btn_click(_:)), for: .touchUpInside
		)
		post_view.help_btn.addTarget(self, action: #selector(help_btn_click(_:)), for: .touchUpInside)
		
		let back_gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.back_btn_click(_:)))
		back_gesture.edges = .left
		view.addGestureRecognizer(back_gesture)
		
		
		self.view.addSubview(post_view)
		post_view.snp.makeConstraints{ (make) in
			make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
			make.height.equalTo(self.view.safeAreaLayoutGuide)
		}
	}
	
	@objc func back_btn_click(_ sender: UIButton)
	{
		self.tabBarController?.tabBar.isHidden = false
		self.navigationController?.popViewController(animated:true)
	}
	@objc func help_btn_click(_ sender: UIButton)
	{
		if (UserDefaults.standard.string(forKey: "name")?.isEmpty ?? true)
		{
			let alert = UIAlertController(title: "알림", message: "로그인이 필요한 서비스입니다.", preferredStyle: UIAlertController.Style.alert)
			
			alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
				let vc = Register_ViewController()
				self.present(vc, animated: true)
			})
			
			self.present(alert, animated: false)
		}
		else if (UserDefaults.standard.string(forKey: "name") == talker_name)
		{
			let alert = UIAlertController(title: "알림", message: "본인의 고민입니다.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "확인", style: .default, handler : nil))
			
			self.present(alert, animated: false)
		}
		else
		{
			//send infrom to talk_VC
			DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.5) {
				NotificationCenter.default.post(name: Notification.Name("talk"), object: self.talker_name)
			}
			
			let parameters =
			[
				"helper_name": UserDefaults.standard.string(forKey: "name") ?? "none",
				"post_title" : post_view.title_label.text ?? "none",
			]
			
			AF.request("http://\(host)/lets_talking", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON() { response in
				switch response.result {
				case .success:
					if let data = try! response.result.get() as? [String: String] {
						if (data["result"] == "success")
						{
							print("let's talking")
							//sent "" for connect
							let connect = RMQConnection(uri: RMQ_host, delegate: RMQConnectionDelegateLogger())
							connect.start()
							let ch = connect.createChannel()
							let q = ch.queue(self.talker_name)
							ch.defaultExchange().publish("/start_talk:\(UserDefaults.standard.string(forKey: "name") ?? "none")".data(using: .utf8)!, routingKey: q.name)

							//move to talk
							self.tabBarController?.tabBar.isHidden = false
							self.tabBarController?.selectedIndex = 1//tabbar click
							self.navigationController?.popViewController(animated:false)
						}
						else if (data["result"] == "already be helped")
						{
							let alert = UIAlertController(title: "알림", message: "이미 상담중인 고민입니다.", preferredStyle: .alert)
							alert.addAction(UIAlertAction(title: "확인", style: .default, handler : nil))
							
							self.present(alert, animated: false)
						}
					}
				case .failure(let error):
					print("Error: \(error)")
				}
			}
			//chaching talker_profile
			save_image(url_string: talker_profile, name: talker_name)
		}
	}
}
