//
//  talk_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/01/28.
//

import UIKit
import SnapKit

class talk_ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let hi = UILabel()
        view.backgroundColor = UIColor.systemBackground
        
        hi.text = "Hi, I'm talk"
        
        view.addSubview(hi)
        
        hi.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        
    }
}
