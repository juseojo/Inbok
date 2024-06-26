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
		self.view.backgroundColor = UIColor(named: "BACKGROUND")
		
		talk_view.talk_tableView.delegate = self
		talk_view.talk_tableView.dataSource = self
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.talk_viewModel.receive(self.talk_view.talk_tableView)
		}

		//receive from chat_vc
		NotificationCenter.default.addObserver(
				self,
				selector: #selector(reload_tableview),
				name: Notification.Name("reload"),
				object: nil
			)
		
		//layout
		self.view.addSubview(talk_view)
		talk_view.snp.makeConstraints{ (make) in
			make.left.top.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		//receive inform from post_vc
		NotificationCenter.default.addObserver(
				self,
				selector: #selector(lets_talk),
				name: Notification.Name("talk"),
				object: nil
			)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(
			self,
			name: Notification.Name("talk"),
			object: nil
		)
	}

	@objc func reload_tableview()
	{
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.talk_view.talk_tableView.reloadData()
			print("reload")
		}
	}
	
	//receive inform from post_vc
	//Clicked help_btn at post_vc
	@objc func lets_talk(talker_name_data : Notification)
	{
		if let talker_name = talker_name_data.object as? String
		{
			let chat = Chat()
			let message = Message()
			DispatchQueue.main.sync {
				
				message.name = talker_name
				message.text = ""
				message.time = date_formatter.string(from: Date())
				message.sent = true
				
				chat.talker.name = talker_name
				chat.talker.helper = false
				
				chat.recent_message = message
				chat.chatting.append(message)

				let realm = try! Realm()
				
				let list = realm.objects(Chat_DB.self).first

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
				let index:IndexPath = IndexPath(
					row:talk_view.talk_tableView.numberOfRows(inSection: 0),
					section: 0
				)
				UIView.performWithoutAnimation {
					talk_view.talk_tableView.insertRows(at: [index], with: .none)
				}
			}
		}
		else
		{
			print("talk_observer_error")
		}

	}
}

//for talk_cell
extension Talk_ViewController: UITableViewDataSource, UITableViewDelegate {
	
	//talkers_num
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		let realm = try! Realm()

		print ("talk cell num:\(realm.objects(Chat_DB.self).first?.chat_list.count ?? -1)")
		return realm.objects(Chat_DB.self).first?.chat_list.count ?? 0
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
		
		let vc = Chat_ViewController(index: indexPath.row)
		
		navigationController?.pushViewController(vc, animated: true)
	}
}
