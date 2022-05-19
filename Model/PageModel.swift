//
//  PageModel.swift
//  PinchApp
//
//  Created by Mindstix on 19/05/22.
//

import Foundation

struct Page : Identifiable {
    let id : Int
    let imageName : String
}

extension Page {
    var thumbanailName: String {
        return "thumb-" + imageName
    }
}
