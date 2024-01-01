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
    }
}

extension UITextView {
	func numberOfLine() -> Int {
		
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
