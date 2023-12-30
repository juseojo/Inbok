//
//  talk_cell.swift
//  Inbok
//
//  Created by seongjun cho on 12/5/23.
//

import UIKit
import SnapKit


class Talk_cell: UITableViewCell {
    
    static let cell_id = "talk"
    
    var profile = UIImageView()
    var nick_name = UILabel()
    var message = UILabel()
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
        self.addSubview(message)
        self.addSubview(time)
        
        profile.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).inset(18)
            make.left.equalTo(self.snp.left).inset(18)
            make.width.height.equalTo(90)
        }
        time.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.snp.bottom).inset(20)
            make.right.equalTo(self.snp.right).inset(20)
            make.width.equalTo(100)
        }
        nick_name.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).inset(18)
            make.left.equalTo(profile.snp.right).inset(-10)
            make.right.equalTo(time.snp.left).inset(-18)
        }
        message.snp.makeConstraints{ (make) in
            make.top.equalTo(nick_name.snp.bottom).inset(5)
            make.left.equalTo(profile.snp.right).inset(10)
            make.right.equalTo(time.snp.left).inset(-18)
        }
    }
}
