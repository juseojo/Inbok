//
//  help_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/21.
//

import UIKit
import SwiftUI
import SnapKit

class help_ViewController: UIViewController {
    
    @objc func click_head_btn(_ sender: UIButton){
        let vc = writePost_ViewController()
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated:true)
    }
    
    var isInfiniteScroll = true
    var offset = 0
    
    var help_model = Help_model(page_name: "당신은 누군가의 인복", head_btn_image: UIImage(named: "edit_document")!)
    
    let help_view = Help_view()
    
    lazy var help_viewModel = Help_viewModel(help_model: help_model)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regist_vc = register_ViewController()
        regist_vc.modalPresentationStyle = .fullScreen
        
        help_view.head_btn.addTarget(self, action: #selector(click_head_btn(_:)), for: .touchUpInside)
        help_viewModel.login(help_vc: self, regist_vc: regist_vc)
        
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
        
        help_viewModel.configure(help_view)
        
        //post
        help_view.post_tableView.delegate = self
        help_view.post_tableView.dataSource = self
        
        //layout
        self.view.addSubview(help_view)
        
        help_view.snp.makeConstraints{ (make) in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(-tabBar_bottom_inset)
        }
        

    }
}


//for post
extension help_ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (offset == 0)
        {
            return 9
        }
        return help_model.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = help_view.post_tableView.dequeueReusableCell(withIdentifier: post_cell.cell_id, for: indexPath) as! post_cell
        cell.backgroundColor = basic_backgroundColor(current_sysbackgroundColor: traitCollection.userInterfaceStyle)
        
        cell  = self.help_viewModel.cell_setting(cell: cell, index: indexPath.row)
        print(indexPath)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height)
        {
            if isInfiniteScroll
            {
                isInfiniteScroll = false
                offset += 1
                
                print("infinity : \(offset)")
                help_viewModel.get_new_post(offset: offset)
                
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
