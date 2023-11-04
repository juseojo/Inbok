//
//  View.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import SnapKit
import UIKit

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height

let head_height: CGFloat = screen_height * 0.05

class Help_view: UIView {
    
    let head_view: UIView = {
        let head_view = UIView()
        
        let line: CALayer = CALayer()

        line.frame = CGRect(x: 0, y: head_height - 0.2, width: screen_width, height: 0.2)
        line.backgroundColor = UIColor.gray.cgColor
        head_view.layer.addSublayer(line)
        
        return head_view
    }()
    
    let head_label: UILabel = {
        let head_label = UILabel()
        head_label.textAlignment = .left
        head_label.textColor = .systemGray
        head_label.font = UIFont(name:"SeoulHangang", size: 20)
        
        return head_label
    }()
    
    let head_btn: UIButton = {
        let head_btn = UIButton()

        return head_btn
    }()
    
    let post_tableView: UITableView = {
        let post_tableView = UITableView()
        post_tableView.rowHeight = 153
        post_tableView.register(post_cell.self, forCellReuseIdentifier: "post")
        
        return post_tableView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        head_view.addSubview(head_label)
        head_view.addSubview(head_btn)

        addSubview(post_tableView)
        addSubview(head_view)
        
        head_view.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(head_height)
        }
        head_label.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view).inset(7)
            make.left.equalTo(head_view).inset(15)
        }
        head_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view).inset(3)
            make.right.equalTo(head_view).inset(15)
            make.bottom.equalTo(head_view).inset(3)
        }
        
        post_tableView.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view.snp.bottom)
            make.width.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
