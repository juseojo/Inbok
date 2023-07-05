//
//  help_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/21.
//

import UIKit
import SwiftUI
import SnapKit
import KakaoSDKAuth
import KakaoSDKUser

import Alamofire

class help_ViewController: UIViewController {
    
    let post_tableView: UITableView = {
        let post_tableView = UITableView()
        post_tableView.rowHeight = 153
        return post_tableView
    }()
    
    @objc func click_head_btn(_ sender: UIButton){
        var vc = wirtePost_ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let vc = register_ViewController()
        vc.modalPresentationStyle = .fullScreen
        
        //run first
        if UserDefaults.standard.bool(forKey: "launchBefore") == false {
            //kakao auth
            print("\nRun first\n")
            self.present(vc, animated: false)
        }
        else if UserDefaults.standard.object(forKey: "oauth_token") == nil
        {
            print("\nNot first run but oauth not found\n")
            self.present(vc, animated: false)
        }
        else
        {
            print("\nNomal login\n\n")
            print(UserDefaults.standard.object(forKey: "oauth_token"))
        }
        
        //tabbar control
        self.tabBarController?.tabBar.layer.borderWidth = 0.1
        self.tabBarController?.tabBar.layer.borderColor = sysBackgroundColor_reversed(current_sysbackgroundColor: traitCollection.userInterfaceStyle).cgColor
        
        let tabBar_bottom_inset = (self.tabBarController?.tabBar.frame.size.height ?? 0) * 0.2
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -tabBar_bottom_inset, right: 0)
        let newTabBarHeight =  (self.tabBarController?.tabBar.frame.size.height ?? 0) - tabBar_bottom_inset - 0.5
        var newFrame = self.tabBarController?.tabBar.frame
        newFrame!.size.height = newTabBarHeight
        newFrame!.origin.y = view.frame.size.height - newTabBarHeight
        
        self.tabBarController?.tabBar.frame = newFrame!
        self.tabBarController?.tabBar.sizeToFit()
        
        navigationController?.isNavigationBarHidden = true
        
        //view, viewModel, model
        view.backgroundColor = basic_backgroundColor(current_sysbackgroundColor: traitCollection.userInterfaceStyle)
        var help_model = Help_model(page_name: "당신은 누군가의 인복", head_btn_image: UIImage(named: "edit_document")!)
        let help_view = Help_view()
        let help_viewModel = Help_viewModel(help_model: help_model)
        
        help_viewModel.configure(help_view)
        
        help_view.head_btn.addTarget(help_view.head_btn, action: #selector(click_head_btn(_:)), for: .touchUpInside)
        
        //post
        post_tableView.register(post_cell.self, forCellReuseIdentifier: "post")
        post_tableView.delegate = self
        post_tableView.dataSource = self
        
        //layout
        help_view.addSubview(post_tableView)
        self.view.addSubview(help_view)
        
        help_view.snp.makeConstraints{ (make) in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(-tabBar_bottom_inset)
        }
        
        post_tableView.snp.makeConstraints{ (make) in
            make.top.equalTo(help_view.head_view.snp.bottom)
            make.width.equalTo(help_view)
            make.bottom.equalTo(help_view)
        }
    }
}

//for post
extension help_ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = post_tableView.dequeueReusableCell(withIdentifier: post_cell.cell_id, for: indexPath) as! post_cell
        
        cell.backgroundColor = basic_backgroundColor(current_sysbackgroundColor: traitCollection.userInterfaceStyle)
        cell.profile.image = UIImage(systemName: "person.fill")
        cell.nick_name.text = "nick"
        cell.problem.text = "I have problem"
        cell.time.text = "1시간 전"
        return cell
    }
}

//for post cell
class post_cell: UITableViewCell {
    
    static let cell_id = "post"
    
    let profile = UIImageView()
    let nick_name = UILabel()
    let problem = UILabel()
    let time = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error")
    }
    
    func layout()
    {
        self.addSubview(profile)
        self.addSubview(nick_name)
        self.addSubview(problem)
        self.addSubview(time)
        
        profile.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).inset(18)
            make.leading.equalTo(self.snp.leading).inset(18)
            make.width.height.equalTo(90)
        }
        nick_name.snp.makeConstraints{ (make) in
            make.top.equalTo(profile.snp.bottom).inset(2)
            make.centerX.equalTo(profile.snp.centerX)
        }
        problem.snp.makeConstraints{ (make) in
            make.top.equalTo(profile.snp.top).inset(25)
            make.left.equalTo(profile.snp.right).inset(-3)
        }
        time.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.snp.bottom).inset(20)
            make.right.equalTo(self.snp.right).inset(20)
        }
        
    }
}
