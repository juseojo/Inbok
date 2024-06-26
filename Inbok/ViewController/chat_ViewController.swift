//
//  chat_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 12/6/23.
//

import UIKit

import RealmSwift
import Alamofire

class Chat_ViewController: UIViewController {

	var index: Int
	var notification: NotificationToken?
    let chat_view = Chat_view()
	lazy var chat_viewModel = Chat_viewModel(index)
	var keyboardRectangle = CGRect()

	init(index: Int) {
		self.index = index
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		//basic set
		self.tabBarController?.tabBar.isHidden = true
		view.backgroundColor = UIColor(named: "BACKGROUND")
		self.navigationController?.isNavigationBarHidden = true
		chat_view.chat_tableView.delegate = self
		chat_view.chat_tableView.dataSource = self

		//back gesture
		let back_gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.back_btn_click(_:)))
		back_gesture.edges = .left
		view.addGestureRecognizer(back_gesture)

		//table view touch gesture
		let table_touch_gesture = UITapGestureRecognizer(target: self, action: #selector(self.table_view_touch))
		chat_view.chat_tableView.addGestureRecognizer(table_touch_gesture)
		
		//button set
		chat_view.back_btn.addTarget(self, action: #selector(back_btn_click(_:)), for: .touchUpInside)
		chat_view.chat_send_button.addTarget(self, action: #selector(send_btn_click(_:)),for: .touchUpInside)
		chat_view.end_btn.addTarget(self, action: #selector(end_btn_click(_:)), for: .touchUpInside)
		
		chat_view.chat_text_view.delegate = self
		
		//layout
		self.view.addSubview(chat_view)
		chat_view.snp.makeConstraints{ (make) in
			make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
			make.top.equalTo(self.view.snp.top)
		}
		
		//chat observing
		let realm = try! Realm()
		let chat = realm.objects(Chat_DB.self).first?.chat_list[index].chatting
		notification = chat?.observe { changes in
			switch changes {
			case .initial(_):
				UIView.performWithoutAnimation {
					DispatchQueue.main.async {
						self.chat_view.chat_tableView.reloadData()
					}
				}
			case .update(_, deletions: _, insertions: _, modifications: _):
				UIView.performWithoutAnimation {
					DispatchQueue.main.async {
						if (chat?.isInvalidated == false)
						{
							let index: IndexPath = IndexPath(row: chat!.count - 2, section: 0)
							self.chat_view.chat_tableView.insertRows(at: [index], with: .none)
							self.chat_view.chat_tableView.scrollToRow(at: index, at: .bottom, animated: false)
						}
					}
				}
			case .error(let error):
				fatalError("\(error)")
			}
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear (_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
	}

	@objc func back_btn_click(_ sender: UIButton)
	{
		self.tabBarController?.tabBar.isHidden = false
		self.navigationController?.popViewController(animated:true)
	}
	
	@objc func end_btn_click(_ sender: UIButton)
	{
		let realm = try! Realm()
		let talker = realm.objects(Chat_DB.self).first?.chat_list[index].talker
		
		var parameters: Dictionary =
		[
			"name": UserDefaults.standard.string(forKey: "name") ?? "none",
			"helper_name": talker?.name ?? "none",
			"solve_flag": true
		] as [String : Any]

		if (talker?.helper == true)
		{
			let alert = UIAlertController(title: "알림", message: "고민이 해결 되셨습니까?. 대답에 따라 상대에게 포인트 지급여부가 결정됩니다.", preferredStyle: UIAlertController.Style.alert)
			
			alert.addAction(UIAlertAction(title: "예", style: .default) { action in
				self.chat_viewModel.end_talking_server(parameters: parameters)
				self.chat_viewModel.end_talking_person(pesrson_name: talker!.name, type: 1)
				self.tabBarController?.tabBar.isHidden = false
				self.navigationController?.popViewController(animated:true)
				self.chat_viewModel.delete_realm_chat(at: self.index) {
					NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				}
			})
			
			alert.addAction(UIAlertAction(title: "아니오", style: .default) { action in
				parameters["solve_flag"] = false
				self.chat_viewModel.end_talking_server(parameters: parameters)
				self.chat_viewModel.end_talking_person(pesrson_name: talker!.name, type: 2)
				self.tabBarController?.tabBar.isHidden = false
				self.navigationController?.popViewController(animated:true)
				self.chat_viewModel.delete_realm_chat(at: self.index){
					NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				}
			})
			
			self.present(alert, animated: false)
			
			let tap = UITapGestureRecognizer(target: self, action: #selector(tab_outside(_:)))
			alert.view.superview?.isUserInteractionEnabled = true
			alert.view.superview?.addGestureRecognizer(tap)
		}
		else
		{
			let alert = UIAlertController(title: "알림", message: "포기 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
			
			alert.addAction(UIAlertAction(title: "예", style: .default) { action in
				parameters["name"] = talker?.name ?? "none"
				parameters["helper_name"] = UserDefaults.standard.string(forKey: "name") ?? "none"
				self.chat_viewModel.end_talking_server(parameters: parameters)
				self.chat_viewModel.end_talking_person(pesrson_name: talker!.name, type: 3)
				self.tabBarController?.tabBar.isHidden = false
				self.navigationController?.popViewController(animated:true)
				self.chat_viewModel.delete_realm_chat(at: self.index){
					NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				}
			})
			
			alert.addAction(UIAlertAction(title: "아니오", style: .default))

			self.present(alert, animated: false)
		}
	}

	@objc private func tab_outside(_ sender: UITapGestureRecognizer)
	{
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func send_btn_click(_ sender: UIButton)
	{
		if (chat_view.chat_text_view.text == "")
		{
			return
		}
		chat_viewModel.send(message: chat_view.chat_text_view.text)
		chat_view.chat_text_view.text = ""

		chat_view.chat_bar_view.snp.updateConstraints{ (make) in
			make.height.equalTo(50)
		}
		if (self.chat_view.chat_tableView.numberOfRows(inSection: 0) > 5)
		{
			chat_view.chat_tableView.snp.updateConstraints{ (make) in
				make.top.equalTo(chat_view).offset(0)
			}
			UIView.animate(
				withDuration: 1
				, animations: {
					self.chat_view.chat_tableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardRectangle.height)
				}
			)
		}
	}

	@objc func table_view_touch(sender: UITapGestureRecognizer)
	{
		self.view.endEditing(true)
	}
	
	@objc func keyboardUp(notification:NSNotification) {
		if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			self.keyboardRectangle = keyboardFrame.cgRectValue
	   
			UIView.animate(
				withDuration: 0.3
				, animations: {
					if (self.chat_view.chat_tableView.numberOfRows(inSection: 0) > 5)
					{
						self.chat_view.chat_tableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardRectangle.height)
					}
					self.chat_view.chat_bar_view.transform = CGAffineTransform(translationX: 0, y: -self.keyboardRectangle.height)
				}
			)
		}
	}

	@objc func keyboardDown() {
		self.chat_view.chat_tableView.transform = .identity
		self.chat_view.chat_bar_view.transform = .identity
	}
}

extension UITextView {
	func numberOfLine() -> Int 	{
		
		let size = CGSize(width: frame.width, height: .infinity)
		let estimatedSize = sizeThatFits(size)
		
		return Int(estimatedSize.height / (self.font!.lineHeight))
	}
}

extension Chat_ViewController: UITextViewDelegate {
	
	func textViewDidChange(_ textView: UITextView) {
		let line_num = textView.numberOfLine()

		//text view's height change by line's number
		switch line_num {
		case 1:
			textView.superview?.snp.updateConstraints{ (make) in
				make.height.equalTo(50)
			}
			break
		case 2:
			textView.superview?.snp.updateConstraints{ (make) in
				make.height.equalTo(70)
			}
			break
		case 3:
			textView.superview?.snp.updateConstraints{ (make) in
				make.height.equalTo(90)
			}
			break
		case 4:
			textView.superview?.snp.updateConstraints{ (make) in
				make.height.equalTo(110)
			}
			break
		default:
			break
		}
	}
}

//for chat_cell
extension Chat_ViewController: UITableViewDataSource, UITableViewDelegate {
	
	//message_num
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
	-> Int
	{
		let realm = try! Realm()

		return (realm.objects(Chat_DB.self).first?.chat_list[index].chatting.count ?? 0) - 1
	}

	//make_cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
	-> UITableViewCell
	{
		let realm = try! Realm()
		let chat = realm.objects(Chat_DB.self).first?.chat_list[index]
		let chat_num = indexPath.row + 1 // [0] is not using object

		if (chat?.chatting[chat_num].sent ?? false)
		{
			var cell =  chat_view.chat_tableView.dequeueReusableCell(
				withIdentifier: Chat_send_cell.cell_id,
				for: indexPath
			) as! Chat_send_cell
			
			cell  = self.chat_viewModel.cell_setting(
				cell: cell,
				index: index,
				num: chat_num
			)

			return cell
		}
		else
		{
			var cell =  chat_view.chat_tableView.dequeueReusableCell(
				withIdentifier: Chat_receive_cell.cell_id,
				for: indexPath
			) as! Chat_receive_cell
			
			cell  = self.chat_viewModel.cell_setting(
				cell: cell,
				index: index,
				num: chat_num
			)

			//talker send end signal to user
			if (cell.name.text == "/end_talk")
			{
				end_talk_alert(type: cell.message.text)
				cell.name.text = ""
				cell.message.text = ""
			}
			return cell
		}
	}
	
	func end_talk_alert(type: String)
	{
		switch type {
		case "1":
			let alert = UIAlertController(title: "상대가 대화를 끝냈습니다.",
										  message: "상대의 고민이 해결되어 포인트를 얻었습니다.",
										  preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "예", style: .default) { action in
				self.tabBarController?.tabBar.isHidden = false
				self.navigationController?.popViewController(animated:true)
				self.chat_viewModel.delete_realm_chat(at: self.index) {
					NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				}
			})
			self.present(alert, animated: false)
			break
		case "2":
			let alert = UIAlertController(title: "상대가 대화를 끝냈습니다.",
										  message: "고민 해결에 실패하여 포인트 흭득에 실패하였습니다.",
										  preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "예", style: .default) { action in
				self.tabBarController?.tabBar.isHidden = false
				self.navigationController?.popViewController(animated:true)
				self.chat_viewModel.delete_realm_chat(at: self.index) {
					NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				}
			})
			self.present(alert, animated: false)
			break
		case "3":
			let alert = UIAlertController(title: "상대가 대화를 끝냈습니다.",
										  message: "상대가 고민 해결을 포기하였습니다.",
										  preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "예", style: .default) { action in
				self.tabBarController?.tabBar.isHidden = false
				self.navigationController?.popViewController(animated:true)
				self.chat_viewModel.delete_realm_chat(at: self.index) {
					NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				}
			})
			self.present(alert, animated: false)
			break
		default:
			print("chat_switch error")
		}
	}
}
