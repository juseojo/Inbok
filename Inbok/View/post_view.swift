//
//  post_view.swift
//  Inbok
//
//  Created by seongjun cho on 11/4/23.
//

import Foundation
import UIKit
import SnapKit

class Post_view : UIView {
    
    let head_view: UIView = {
        let head_view = UIView()
        
        let line: CALayer = CALayer()

        line.frame = CGRect(x: 0, y: head_height - 0.2, width: screen_width, height: 0.2)
        line.backgroundColor = UIColor.gray.cgColor
        head_view.layer.addSublayer(line)
        
        return head_view
    }()
    
    let back_btn: UIButton = {
        let back_btn = UIButton()
        
        back_btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        back_btn.tintColor = UIColor.gray
        
        return back_btn
    }()
    
    //sizeThatFits 해서 크기 맞추자
    var title_label: UILabel = {
        var title_label = UILabel()
        title_label.textAlignment = .left
        
        title_label.text = "제목 테스트"
        return title_label
    }()
    
    var problem_label:UILabel = {
        var problem_label = UILabel()
        problem_label.textAlignment = .left
        
        problem_label.text = "고민 테스트"
        return problem_label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor(named:"BACKGROUND")
        addSubview(head_view)
        head_view.addSubview(back_btn)
        addSubview(title_label)
        addSubview(problem_label)
        
        head_view.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(head_height)
        }
        
        back_btn.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view).inset(3)
            make.left.equalTo(head_view).inset(15)
            make.bottom.equalTo(head_view).inset(3)
        }
        
        title_label.snp.makeConstraints{ (make) in
            make.top.equalTo(head_view.snp.bottom)
            make.left.right.equalTo(self)
        }
        problem_label.snp.makeConstraints{ (make) in
            make.top.equalTo(title_label.snp.bottom)
            make.left.right.equalTo(self)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
