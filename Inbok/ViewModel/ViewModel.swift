//
//  ViewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation

class Need_bok_viewModel {
    let need_bok: Need_bok
    init(){
        self.need_bok = Need_bok()
    }
    
    var top_text: String {
        return need_bok.page_name
    }
}

extension Need_bok_viewModel {
    func configure(_ view: Need_bok_view) {
        view.top_label.text = top_text
    }
}
