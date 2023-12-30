//
//  talk_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/01/28.
//

import UIKit
import SnapKit
import RealmSwift

class Talk_ViewController: UIViewController {
	
	let talk_view = Talk_view()
	let talk_viewModel = Talk_viewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//setting
		navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(
			named: "BACKGROUND"
		)
		
		talk_view.talk_tableView.delegate = self
		talk_view.talk_tableView.dataSource = self
		
		//receive inform from post_vc
		add_notiObserver()
		
		//receiving ON - Need to think more better way
		//talk_viewModel.receive(talk_view.talk_tableView)
		
		//layout
		self.view.addSubview(
			talk_view
		)
		talk_view.snp.makeConstraints{ (
			make
		) in
			make.left.top.right.bottom.equalTo(
				self.view.safeAreaLayoutGuide
			)
		}
	}
	
	//receive inform from post_vc
	//Clicked help_btn at post_vc
	@objc func lets_talk(partner_inform : Notification)
	{
		if let talker_name_profile = partner_inform.object as? [String:String]
		{
			DispatchQueue.main.sync {
				let chat = Chat()
				let message = Message()
				
				message.name = talker_name_profile["name"]!
				message.text = ""
				message.time = Date().toString()
				message.profile_image = talker_name_profile["profile_image"]!
				
				chat.recent_message = message
				chat.helping = true
				chat.chatting.append(message)
				chat.index = talk_viewModel.talk_model.chat_DB.objects(Chat.self).count

				try! talk_viewModel.talk_model.chat_DB.write{
					talk_viewModel.talk_model.chat_DB.add(chat)
				}

				//append tableview element
				let index:IndexPath = IndexPath(
					row:chat.index - 1,
					section: 0
				)
				
				UIView.performWithoutAnimation {
					talk_view.talk_tableView.insertRows(
						at: [index],
						with: .none
					)
				}
			}
		}
		else
		{
			print(
				"talk_observer_error"
			)
		}
		
		//move to talking view
		
	}
	
	//recieve setting
	private func add_notiObserver()
	{
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(
				lets_talk
			),
			name: Notification.Name(
				"talk"
			),
			object: nil
		)
	}
}

//for talk_cell
extension Talk_ViewController: UITableViewDataSource, UITableViewDelegate {
	
	//talkers_num
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
	-> Int
	{
		print("\n\n\(talk_viewModel.talk_model.chat_DB.objects(Chat.self).count)")
		return talk_viewModel.talk_model.chat_DB.objects(Chat.self).count
	}
	
	//make_cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
	-> UITableViewCell
	{
		var cell =  talk_view.talk_tableView.dequeueReusableCell(
			withIdentifier: Talk_cell.cell_id,
			for: indexPath
		) as! Talk_cell

		cell.backgroundColor = UIColor(named: "BACKGROUND")
		
		cell  = self.talk_viewModel.cell_setting(
			cell: cell,
			index: indexPath.row
		)

		return cell
	}
	
	//choose_talker
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: false)
		
		let vc = Chat_ViewController()
		
		navigationController?.pushViewController(vc, animated: true)
	}
}
