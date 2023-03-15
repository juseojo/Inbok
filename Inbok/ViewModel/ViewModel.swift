//
//  ViewModel.swift
//  Inbok
//
//  Created by seongjun cho on 2022/12/22.
//

import Foundation

class Help_viewModel {
    let help_model: Help_model
    init(){
        self.help_model = Help_model()
    }
    
    var top_text: String {
        return help_model.page_name
    }
}

extension Help_viewModel {
    func configure(_ view: Help_view) {
        view.top_label.text = top_text
    }
}
