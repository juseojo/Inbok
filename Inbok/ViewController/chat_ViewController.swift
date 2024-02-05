//
//  chat_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 12/6/23.
//

import Foundation
import UIKit
import RealmSwift

class Chat_ViewController: UIViewController {

	var index: Int
	var notification: NotificationToken?
    let chat_view = Chat_view()
	lazy var chat_viewModel = Chat_viewModel(index)

	init(index: Int) {
		self.index = index
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func back_btn_click(_ sender: UIButton)
	{
		self.tabBarController?.tabBar.isHidden = false
		self.navigationController?.popViewController(animated:true)
	}
	
	@objc func send_btn_click(_ sender: UIButton)
	{
		chat_viewModel.send(message: chat_view.chat_text_view.text)
		chat_view.chat_text_view.text = ""
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

		
		//button set
		chat_view.back_btn.addTarget(self, action: #selector(back_btn_click(_:)), for: .touchUpInside
		)
		
		chat_view.chat_send_button.addTarget(self, action: #selector(send_btn_click(_:)),
			for: .touchUpInside
		)
		
		chat_view.chat_text_view.delegate = self
		
		
        self.view.addSubview(chat_view)
		
		chat_view.snp.makeConstraints{ (make) in
			make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
			make.height.equalTo(self.view.safeAreaLayoutGuide)
		}
		
		let realm = try! Realm()
		let chat = realm.objects(Chat_DB.self).first?.chat_list[index].chatting
		notification = chat?.observe { changes in
		let index: IndexPath = IndexPath(row: chat!.count - 2, section: 0)

			switch changes {
				
			case .initial(_):
				UIView.performWithoutAnimation {
					DispatchQueue.main.async {
						self.chat_view.chat_tableView.reloadData()
						self.chat_view.chat_tableView.scrollToRow(at: index, at: .bottom, animated: false)
					}
				}
			case .update(_, deletions: _, insertions: _, modifications: _):
				UIView.performWithoutAnimation {
					DispatchQueue.main.async {
						self.chat_view.chat_tableView.insertRows(at: [index], with: .none)
						self.chat_view.chat_tableView.scrollToRow(at: index, at: .bottom, animated: false)
					}
				}
			case .error(let error):
				fatalError("\(error)")
			}
		}
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

		print ("count :  \((realm.objects(Chat_DB.self).first?.chat_list[index].chatting.count ?? 0) - 1)")
		return (realm.objects(Chat_DB.self).first?.chat_list[index].chatting.count ?? 0) - 1
	}

	//make_cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
	-> UITableViewCell
	{
		let realm = try! Realm()
		let chat = realm.objects(Chat_DB.self).first?.chat_list[index]
		let chat_num = indexPath.row + 1 // [0] is none useing object

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

			return cell
		}
	}
}
