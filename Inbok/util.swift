//
//  util.swift
//  Inbok
//
//  Created by seongjun cho on 2023/06/19.
//

import Foundation
import UIKit

//need traitCollection.userInterfaceStyle
func sysBackgroundColor_reversed(current_sysbackgroundColor : UIUserInterfaceStyle) -> UIColor
{
    if (current_sysbackgroundColor == .light)
    {
        return .black
    }
    else
    {
        return .white
    }
}

//need traitCollection.userInterfaceStyle
func basic_backgroundColor(current_sysbackgroundColor : UIUserInterfaceStyle) -> UIColor
{
    if (current_sysbackgroundColor == .light)
    {
        return .white

    }
    else
    {
        return .systemGray6
    }
}
