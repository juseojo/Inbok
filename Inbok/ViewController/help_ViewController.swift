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
    
    let post_table_view: UITableView = {
        let post_table_view = UITableView()
        post_table_view.rowHeight = 153
        return post_table_view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.systemBackground
        let need_bok_view = Need_bok_view()
        let viewModel = Need_bok_viewModel()
        
        viewModel.configure(need_bok_view)
        
        post_table_view.register(post_cell.self, forCellReuseIdentifier: "post")
        post_table_view.delegate = self
        post_table_view.dataSource = self
        
        need_bok_view.addSubview(post_table_view)
        self.view.addSubview(need_bok_view)
        
        need_bok_view.snp.makeConstraints{ (make) in
            make.left.top.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        post_table_view.snp.makeConstraints{ (make) in
            make.top.equalTo(need_bok_view.top_view.snp.bottom)
            make.width.equalTo(need_bok_view)
            make.bottom.equalTo(need_bok_view)
        }
    }
}

extension help_ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = post_table_view.dequeueReusableCell(withIdentifier: post_cell.cell_id, for: indexPath) as! post_cell
        
        cell.profile.image = UIImage(named: "edit_document")
        cell.nick_name.text = "nick"
        cell.problem.text = "I have problem"
        cell.time.text = "1시간 전"
        return cell
    }
}

class post_cell: UITableViewCell {
    
    static let cell_id = "post"
    
    let profile = UIImageView()
    let nick_name = UILabel()
    let problem = UILabel()
    let time = UILabel()
    
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
        self.addSubview(problem)
        self.addSubview(time)
        
        profile.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).inset(18)
            make.leading.equalTo(self.snp.leading).inset(18)
            make.width.height.equalTo(90)
        }
        nick_name.snp.makeConstraints{ (make) in
            make.top.equalTo(profile.snp.bottom).inset(2)
            make.centerX.equalTo(profile.snp.centerX)
        }
        problem.snp.makeConstraints{ (make) in
            make.top.equalTo(profile.snp.top).inset(25)
            make.left.equalTo(profile.snp.right).inset(-3)
        }
        time.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.snp.bottom).inset(20)
            make.right.equalTo(self.snp.right).inset(20)
        }
        
    }
}



//for free view
 struct PreView: PreviewProvider {
 static var previews: some View {
 help_ViewController().toPreview()
 }
 }
 
 
 #if DEBUG
 extension UIViewController {
 private struct Preview: UIViewControllerRepresentable {
 let help_ViewController: UIViewController
 
 func makeUIViewController(context: Context) -> UIViewController {
 return help_ViewController
 }
 
 func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
 }
 }
 
 func toPreview() -> some View {
 Preview(help_ViewController: self)
 }
 }
 #endif
 //end preview
