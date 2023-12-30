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
    
    let chat_view = Chat_view()
    let chat_viewModel = Chat_viewModel()

	@objc func back_btn_click(_ sender: UIButton)
	{
		self.tabBarController?.tabBar.isHidden = false
		self.navigationController?.popViewController(animated:true)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.tabBarController?.tabBar.isHidden = true
		view.backgroundColor = UIColor(named: "BACKGROUND")
		self.navigationController?.isNavigationBarHidden = true

		let back_gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.back_btn_click(_:)))
		back_gesture.edges = .left
		view.addGestureRecognizer(back_gesture)

		chat_view.back_btn.addTarget(self, action: #selector(back_btn_click(_:)), for: .touchUpInside
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

		switch line_num {
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
