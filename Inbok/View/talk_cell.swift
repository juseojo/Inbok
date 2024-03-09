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
        
		profile.tintColor = UIColor.gray
		
        profile.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).inset(18)
            make.left.equalTo(self.snp.left).inset(18)
            make.width.height.equalTo(90)
        }
        //time layout -> talk_viewModel

        nick_name.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).inset(18)
            make.left.equalTo(profile.snp.right).inset(-10)
            make.right.equalTo(time.snp.left).inset(-18)
        }
        message.snp.makeConstraints{ (make) in
            make.top.equalTo(nick_name.snp.bottom).inset(-10)
			make.left.equalTo(nick_name)
            make.right.equalTo(time.snp.left).inset(-18)
        }
    }
}
