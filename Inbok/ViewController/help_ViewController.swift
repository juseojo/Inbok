//
//  help_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/21.
//

import UIKit
import SwiftUI
import SnapKit

class Help_ViewController: UIViewController {
    
	var isInfiniteScroll = true
	var offset = 0
	
	//view, view_model, model
	let help_view = Help_view()
	let help_model = Help_model()
	lazy var help_viewModel = Help_viewModel(help_model: help_model)

	override func viewDidLoad() {
		super.viewDidLoad()
		
		help_view.head_btn.addTarget(self, action: #selector(click_head_btn(_:)), for: .touchUpInside)
		//try login
		if (help_viewModel.login() == false)
		{
			let regist_vc = Register_ViewController()
			self.present(regist_vc, animated: false)
		}
		
		view.backgroundColor = UIColor(named: "BACKGROUND")
		
		//post
		help_view.post_tableView.delegate = self
		help_view.post_tableView.dataSource = self
		let refresh_controll : UIRefreshControl = UIRefreshControl()
		refresh_controll.addTarget(self, action: #selector(self.refresh_posts), for: .valueChanged)
		help_view.post_tableView.refreshControl = refresh_controll
		help_viewModel.get_new_post(offset: 0) { isError in
			if (isError)
			{
				DispatchQueue.main.async {
					self.dismiss(animated: false)
				}
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
					let alert = UIAlertController(title: "알림", message: "서버 점검중입니다. 다음에 다시 시도해주세요.", preferredStyle: UIAlertController.Style.alert)
					self.present(alert, animated: false)
				}
			}
		}
		self.help_model.posts.removeFirst()
		
		//layout
		navigationController?.isNavigationBarHidden = true
		self.view.addSubview(help_view)
		
		help_view.snp.makeConstraints{ (make) in
			make.left.top.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
		}
	}

	@objc func click_head_btn(_ sender: UIButton){
		
		if (UserDefaults.standard.string(forKey: "name")?.isEmpty ?? true)
		{
			let alert = UIAlertController(title: "알림", message: "로그인이 필요한 서비스입니다.", preferredStyle: UIAlertController.Style.alert)
			
			alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
				let vc = Register_ViewController()
				self.present(vc, animated: true)
			})
			
			self.present(alert, animated: false)
		}
		else
		{
			let vc = WritePost_ViewController()

			vc.modalPresentationStyle = .fullScreen
			navigationController?.pushViewController(vc, animated: true)
		}
	}
    
    @objc func refresh_posts(){
        self.help_model.posts.removeAll()
        offset = 0
		help_viewModel.get_new_post(offset: 0) { isError in
			if (isError)
			{
				DispatchQueue.main.async {
					self.dismiss(animated: false)
				}
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
					let alert = UIAlertController(title: "알림", message: "서버 점검중입니다. 다음에 다시 시도해주세요.", preferredStyle: UIAlertController.Style.alert)
					self.present(alert, animated: false)
				}
			}
		}
		
		isInfiniteScroll = true
        help_view.post_tableView.refreshControl!.endRefreshing()
        help_view.post_tableView.reloadData()
    }
}

//for post
extension Help_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    //posts_ea
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return help_model.posts.count 
    }
    
    //make_cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = help_view.post_tableView.dequeueReusableCell(withIdentifier: Post_cell.cell_id, for: indexPath) as! Post_cell
        cell.backgroundColor = UIColor(named: "BACKGROUND")
        
        cell  = self.help_viewModel.cell_setting(cell: cell, index: indexPath.row)

        return cell
    }
    
    //choose_post
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)

        let vc = Post_ViewController()
        
        //for send to talk_view
        vc.talker_name = help_model.posts[indexPath.row]["name"] ?? "none"
        vc.talker_profile = help_model.posts[indexPath.row]["profile_image"] ?? "none"
		
		//post view text setting
		vc.post_view.point_label.text = ": \(help_model.posts[indexPath.row]["point"] ?? "error")"
        vc.post_view.title_label.text = help_model.posts[indexPath.row]["title"]
        vc.post_view.problem_label.text = help_model.posts[indexPath.row]["content"]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //infinity_scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height)
        {
            if isInfiniteScroll
            {
                isInfiniteScroll = false
                offset += 1
                
                print("infinity : \(offset)")
				help_viewModel.get_new_post(offset: offset) { isError in
					if (isError)
					{
						DispatchQueue.main.async {
							self.dismiss(animated: false)
						}
						DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
							let alert = UIAlertController(title: "알림", message: "서버 점검중입니다. 다음에 다시 시도해주세요.", preferredStyle: UIAlertController.Style.alert)
							self.present(alert, animated: false)
						}
					}
				}
                
                var index = [IndexPath]()
                
                for cnt in 0...8
                {
                    if (offset * 9 + cnt < self.help_model.posts.count)
                    {
                        index.append([0, offset * 9 + cnt])
                    }
                }
                
                UIView.performWithoutAnimation {
                    self.help_view.post_tableView.insertRows(at: index, with: .none)
                }

                isInfiniteScroll = true
                if (index.isEmpty)
                {
                    isInfiniteScroll = false
                }
            }
        }
    }
}
