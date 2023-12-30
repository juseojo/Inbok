//
//  helpPost_cell_view.swift
//  Inbok
//
//  Created by seongjun cho on 2023/09/07.
//

import UIKit
import SnapKit


class post_cell: UITableViewCell {
    
    static let cell_id = "post"
    
    var profile = UIImageView()
    var nick_name = UILabel()
    var title = UILabel()
    var time = UILabel()
    
    
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
        self.addSubview(title)
        self.addSubview(time)
        
        profile.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).inset(18)
            make.leading.equalTo(self.snp.leading).inset(18)
            make.width.height.equalTo(90)
        }
        nick_name.snp.makeConstraints{ (make) in
            make.top.equalTo(profile.snp.bottom).inset(-10)
            make.centerX.equalTo(profile.snp.centerX)
        }
        title.snp.makeConstraints{ (make) in
            make.top.equalTo(profile.snp.top).inset(20)
            make.left.equalTo(profile.snp.right).inset(-10)
            make.right.equalTo(self.snp.right).inset(20)
        }
        time.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.snp.bottom).inset(20)
            make.right.equalTo(self.snp.right).inset(20)
        }
        
    }
}
