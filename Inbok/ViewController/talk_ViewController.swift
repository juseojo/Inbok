//
//  talk_ViewController.swift
//  Inbok
//
//  Created by seongjun cho on 2023/01/28.
//

import UIKit
import SnapKit

class talk_ViewController: UIViewController {
    
    let talk_view = Talk_view()
    let talk_viewModel = Talk_viewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.systemBackground
        self.view.backgroundColor = UIColor(named: "BACKGROUND")
        
        add_notiObserver()
        
        //layout
        self.view.addSubview(talk_view)
        talk_view.snp.makeConstraints{ (make) in
            make.left.top.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func lets_talk(partner_inform : Notification)
    {
        if let talker_name = partner_inform.object as? String
        {
            DispatchQueue.main.sync {
                //remove none_label
                let remove_tag = talk_view.viewWithTag(100)
                remove_tag?.removeFromSuperview()
                
                //add talking_view
                talk_view.addSubview(talk_view.talking_view)
                talk_view.talking_view.snp.makeConstraints{ (make) in
                    make.top.equalTo(talk_view.head_view.snp.bottom)
                    make.left.right.bottom.equalTo(talk_view)
                }
                
            }
        }
        else
        {
            print("talk_observer_error")
        }
    }
    
    private func add_notiObserver()
    {
        NotificationCenter.default.addObserver(
                                            self,
                                            selector: #selector(lets_talk),
                                            name: Notification.Name("talk"),
                                            object: nil)
    }
    
    
    
}
