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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //run first
        if UserDefaults.standard.bool(forKey: "launchBefore") == false {
            //kakao auth
            print("\nrun first\n")
            
            self.present(register_ViewController(), animated: false)
        }
        
        if UserDefaults.standard.object(forKey: "oauth_token") == nil
        {
            print("\nnot first run but auth not found\n")
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        exit(0)
                    }
                    else {
                        print("\noauth save\n")
                        UserDefaults.standard.set(oauthToken?.idToken, forKey: "oauth_token")
                        print(UserDefaults.standard.object(forKey: "oauth_token"))
                    }
                }
                UserDefaults.standard.set(true, forKey: "launchBefore")
            }
        }
        else
        {
            print("\n\n nomal login \n\n")
            print(UserDefaults.standard.object(forKey: "oauth_token"))
        }
        
        //tabbar control
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = UIColor.gray.cgColor
        
        let tabBar_bottom_inset = (self.tabBarController?.tabBar.frame.size.height ?? 0) * 0.2
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -tabBar_bottom_inset, right: 0)
        let newTabBarHeight =  (self.tabBarController?.tabBar.frame.size.height ?? 0) - tabBar_bottom_inset - 0.5
        var newFrame = self.tabBarController?.tabBar.frame
        newFrame!.size.height = newTabBarHeight
        newFrame!.origin.y = view.frame.size.height - newTabBarHeight
        self.tabBarController?.tabBar.frame = newFrame!
        self.tabBarController?.tabBar.sizeToFit()
        
        navigationController?.isNavigationBarHidden = true
        
        //view, viewModel
        view.backgroundColor = UIColor.systemBackground
        let help_view = Help_view()
        let help_viewModel = Help_viewModel()
        
        help_viewModel.configure(help_view)
        
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
            make.top.equalTo(help_view.top_view.snp.bottom)
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
