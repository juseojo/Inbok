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
        view.backgroundColor = UIColor.systemBackground
        
        let talk_view = Talk_view()
        let talk_viewModel = Talk_viewModel()
        
        talk_viewModel.configure(talk_view)
        
        self.view.addSubview(talk_view)
        talk_view.snp.makeConstraints{ (make) in
            make.left.top.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
