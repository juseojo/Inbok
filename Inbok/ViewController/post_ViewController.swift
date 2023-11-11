//
//  post_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 11/7/23.
//

import UIKit
import SnapKit

class post_ViewController : UIViewController {
    
    let post_view = Post_view()
    
    @objc func back_btn_click(_ sender: UIButton)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated:true)
    }
    
    override func viewDidLoad() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.backgroundColor = UIColor(named: "BACKGROUND")
        post_view.backgroundColor = UIColor(named: "BACKGROUND")
        
        post_view.back_btn.addTarget(self, action: #selector(back_btn_click(_:)), for: .touchUpInside
        )
        let back_gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.back_btn_click(_:)))
        back_gesture.edges = .left
        view.addGestureRecognizer(back_gesture)
        
        
        self.view.addSubview(post_view)
        post_view.snp.makeConstraints{ (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
